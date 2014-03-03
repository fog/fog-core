require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'
require 'vcr'
require "minitest-vcr"
require "webmock"
require "faraday"

VCR.configure do |c|
    c.cassette_library_dir = 'spec/cassettes'
    c.hook_into :webmock
end


MinitestVcr::Spec.configure!