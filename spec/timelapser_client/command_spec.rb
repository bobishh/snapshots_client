require 'spec_helper'
require 'timelapser_client/command'

RSpec.describe TimelapserClient::Command do
  let(:mocked_command) { instance_double(TimelapserClient::Command::Shoot) }
  subject { described_class.new(:shoot, result_path: 'spec/files/videos') }

  context ':shoot' do
    specify '#command returns command class' do
      expect(subject.command).to be_kind_of(TimelapserClient::Command::Shoot)
    end

    specify '#options has command options' do
      expect(subject.options).to include(result_path: 'spec/files/videos')
    end

    describe '#run!' do
      before do
        allow(subject).to receive(:command).and_return(mocked_command)
        allow(mocked_command).to receive(:run!).and_return(nil)
      end

      it 'delegates #run! to command' do
        expect(mocked_command).to receive(:run!)
        subject.run!
      end
    end
  end
end
