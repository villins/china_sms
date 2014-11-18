# encoding: utf-8
require 'spec_helper'

describe "Luosimao" do
  let(:username) { 'api' }
  let(:password) { 'password' }
  describe "luosimao#to" do
    let(:url) { "https://sms-api.luosimao.com/v1/send.json" }
    let(:content) { '【畅友短信测试】深圳 Rubyist 活动时间变更到周六下午 3:00，请留意。【19屋】' }
    subject { ChinaSMS::Service::Luosimao.to phone, content, username: username, password: password }

    describe 'single phone' do
      let(:phone) { '13928935535' }

      before do
        stub_request(:post, "https://#{username}:#{password}@sms-api.luosimao.com/v1/send.json").
          with(:body => {"message"=> content, "mobile"=> phone}).to_return(body: '{"error":0,"msg":"ok"}')
      end

      its([:success]) { should eql true }
      its([:code]) { should eql 0 }
      its([:message]) { should eql "ok" }
    end
  end

  describe "luosimao#get" do
    let(:url) { "https://sms-api.luosimao.com/v1/status.json" }
    subject { ChinaSMS::Service::Luosimao.get username: username, password: password }
    describe 'get success' do
      before do
        stub_request(:get, "https://#{username}:#{password}@sms-api.luosimao.com/v1/status.json")
          .to_return(body: '{"error":0, "deposit":"71430"}')
      end

      its(['deposit']) { should eql "71430" }
      its(['error']) { should eql 0 }
    end
  end

end
