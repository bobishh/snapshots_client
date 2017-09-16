require 'spec_helper'
require 'timelapser_client/settings'

RSpec.describe TimelapserClient::Settings do
  describe 'reads config file to get values' do
    let(:file_string) { File.read('spec/fixtures/files/secrets.yml') }
    before do
      allow(File).to receive(:read).with('config/secret.yml').and_return(file_string)
    end

    specify '.token' do
      expect(described_class.token).to eq('TOKEN')
    end

    specify '.endpoint' do
      expect(described_class.endpoint).to eq('https://example.net')
    end

    specify '.snapshots_path' do
      expect(described_class.snapshots_path).to eq('spec/fixtures/files/images/')
    end
  end
end
