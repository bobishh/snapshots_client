require 'spec_helper'
require 'timelapser_client/command/send'

RSpec.describe TimelapserClient::Command::Send do
  let(:endpoint) { 'www.example.com' }

  let(:options) do
    { image: 'spec/fixtures/files/snapshot_20170915_1944.jpg',
      endpoint: endpoint,
      camera_id: 'id',
      token: 'BLABLA' }
  end

  let(:call_result) { { status: 200, body: '{"snapshot":{"id":42}}' } }

  subject { described_class.new(options) }

  before do
    stub_request(:post, endpoint)
      .to_return(call_result)
  end

  describe '#run!' do
    context 'success' do
      it 'returns success:true and created snapshot id' do
        expect(subject.run!).to include(success: true, id: 42)
      end
    end

    context 'failure' do
      let(:call_result) do
        { status: 422,
          body: '{"errors": {"image":"corrupted_file"}}' }
      end

      it 'returns success:false and errors hash' do
        expected = { success: false, errors: { 'image' => 'corrupted_file' } }
        expect(subject.run!).to include(expected)
      end
    end
  end

  describe '#command' do
    it 'returns instance of Curl::Easy' do
      expect(subject.command).to be_kind_of(Curl::Easy)
    end
  end
end
