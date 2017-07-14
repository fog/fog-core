require "spec_helper"
require "fog/compute/models/server"

describe Fog::Compute::Server do
  before do
    @server = Fog::Compute::Server.new
  end

  describe "#sshable?" do
    before do
      # I'm not sure why #sshable? depends on a method that's not defined except in implementing classes
      def @server.ready?;end
    end

    describe "when the server is not ready" do
      it "is false" do
        @server.stub(:ready?, false) do
          assert @server.sshable? == false
        end
      end
    end

    describe "when the server is ready" do
      describe "when the ssh_ip_address is nil" do
        it "is false" do
          @server.stub(:ready?, true) do
            @server.stub(:ssh_ip_address, nil) do
              assert @server.sshable? == false
            end
          end
        end
      end


      describe "when the ssh_ip_address exists" do
        # Define these constants which would be imported by net-ssh once loaded
        module Net
          module SSH
            class AuthenticationFailed  < RuntimeError
            end
            class Disconnect < RuntimeError
            end
          end
        end

        describe "and ssh times out" do
          it "is false" do
            @server.stub(:ready?, true) do
              @server.stub(:ssh_ip_address, "10.0.0.1") do
                raises_timeout = -> (_time) { raise Timeout::Error.new }
                Timeout.stub(:timeout, raises_timeout) do
                  assert @server.sshable? == false
                end
              end
            end
          end
        end

        describe "and it raises Net::SSH::AuthenticationFailed" do
          it "is false" do
            @server.stub(:ready?, true) do
              @server.stub(:ssh_ip_address, "10.0.0.1") do
                raises_timeout = -> (_cmd, _options) { raise Net::SSH::AuthenticationFailed.new }
                @server.stub(:ssh, raises_timeout) do
                  assert @server.sshable? == false
                end
              end
            end
          end
        end

        describe "and it raises Net::SSH::Disconnect" do
          it "is false" do
            @server.stub(:ready?, true) do
              @server.stub(:ssh_ip_address, "10.0.0.1") do
                raises_timeout = -> (_cmd, _options) { raise Net::SSH::Disconnect.new }
                @server.stub(:ssh, raises_timeout) do
                  assert @server.sshable? == false
                end
              end
            end
          end
        end

        describe "and it raises SystemCallError" do
          it "is false" do
            @server.stub(:ready?, true) do
              @server.stub(:ssh_ip_address, "10.0.0.1") do
                raises_timeout = -> (_cmd, _options) { raise SystemCallError.new("message, 0") }
                @server.stub(:ssh, raises_timeout) do
                  assert @server.sshable? == false
                end
              end
            end
          end
        end

        describe "and ssh completes within the designated timeout" do
          it "is true" do
            @server.stub(:ready?, true) do
              @server.stub(:ssh_ip_address, "10.0.0.1") do
                @server.stub(:ssh, "datum") do
                  assert @server.sshable? == true
                end
              end
            end
          end
        end

      end
    end

  end
end
