require_relative 'spec_helper'

describe "credentials" do
  before do
    @old_home = ENV['HOME']
    @old_rc   = ENV['FOG_RC']
    @old_credential = ENV['FOG_CREDENTIAL']
    @old_credentials = Fog.credentials
    Fog.instance_variable_set('@credential_path', nil) # kill memoization
    Fog.instance_variable_set('@credential', nil) # kill memoization
  end

  after do
    ENV['HOME'] = @old_home
    ENV['FOG_RC'] = @old_rc
    ENV['FOG_CREDENTIAL'] = @old_credential
    Fog.credentials = @old_credentials
  end

  describe "credential" do
    it "returns :default for default credentials" do
      assert_equal :default, Fog.credential
    end

    it "returns the to_sym of the assigned value" do
      Fog.credential = "foo"
      assert_equal :foo, Fog.credential
    end

    it "can set credentials throught he FOG_CREDENTIAL env va" do
      ENV["FOG_CREDENTIAL"] = "bar"
      assert_equal :bar, Fog.credential
    end
  end

  describe "credentials_path"  do
    it "has FOG_RC takes precedence over HOME" do
      ENV['HOME'] = '/home/path'
      ENV['FOG_RC'] = '/rc/path'

      assert_equal '/rc/path', Fog.credentials_path
    end

    it "properly expends paths" do
      ENV['FOG_RC'] = '/expanded/subdirectory/../path'
      assert_equal '/expanded/path', Fog.credentials_path
    end

    
    it "alls back to home path if FOG_RC not set" do
      ENV.delete('FOG_RC')
      assert_equal File.join(ENV['HOME'], '.fog'), Fog.credentials_path
    end

    it "ignores home path if it does not exist" do
      ENV.delete('FOG_RC')
      ENV['HOME'] = '/no/such/path'
      assert_nil Fog.credentials_path
    end

    it "File.expand_path raises because of non-absolute path" do
      ENV.delete('FOG_RC')
      ENV['HOME'] = '.'

      if RUBY_PLATFORM == 'java'
        Fog::Logger.warning("Stubbing out non-absolute path credentials test due to JRuby bug: https://github.com/jruby/jruby/issues/1163")
      else
        assert_equal nil, Fog.credentials_path
      end
    end

    it "returns nil when neither FOG_RC or HOME are set" do
      ENV.delete('HOME')
      ENV.delete('FOG_RC')
      assert_nil Fog.credentials_path
    end
  end

  describe "symbolize_credential?" do
    it "returns false if the value is :headers" do
      refute Fog.symbolize_credential?(:headers)
    end

    it "retursns true if the alue is not :headers" do
      assert Fog.symbolize_credential?(:foo)
      assert Fog.symbolize_credential?(:liberate_me_ex_inheris)
    end
  end

  describe "symbolize_credentials" do
    it "converts all of the keys to symbols based on symbolize_credential?" do
      h = {
        "a" => 3,
        :something => 2,
        "connection_options" => {"val" => 5},
        :headers => { 'User-Agent' => "my user agent" }
      }

      expected = {
        :a => 3,
        :something => 2,
        :connection_options => {:val => 5},
        :headers => { 'User-Agent' => "my user agent" }
      }

      assert_equal expected, Fog.symbolize_credentials(h)
    end
  end
end
