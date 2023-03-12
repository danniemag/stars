# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegisterUserStarsService, type: :service do
  describe 'class' do
    describe '.call' do
      it 'creates a new instance of the service and calls it' do
        username = 'seliksy'
        item = []

        service_instance = double(described_class)
        allow(described_class).to receive(:new).with(username, item).and_return(service_instance)
        allow(service_instance).to receive(:call).and_return('the end result')

        expect(described_class.call(username, item)).to eq 'the end result'
      end
    end
  end

  describe '#call' do
    let(:username) { 'lorem-ipsum' }
    subject(:service) { described_class.new(username, item) }

    context 'when user has no repos' do
      let(:item) { [] }

      it 'returns nothing' do
        expect(subject.call).to be_nil
      end
    end

    context 'when user has repos' do
      let(:item) do
        [
          {
            'id' => 123455678,
            'name' => 'my-first-repo',
            'full_name' => 'lorem-ipsum/my-first-repo',
            'private' => false,
            'stargazers_count' => 0,
            'watchers_count' => 0,
            'visibility' => 'public',
            'forks' => 0,
            'open_issues' => 0,
            'watchers' => 0,
            'default_branch' => 'master'},
          {
            'id' => 987655432,
            'name' => 'my-second-repo',
            'full_name' => 'lorem-ipsum/my-second-repo',
            'private' => false,
            'stargazers_count' => 1,
            'watchers_count' => 1,
            'visibility' => 'public',
            'forks' => 0,
            'open_issues' => 9,
            'watchers' => 1,
            'default_branch' => 'master'
          }
        ]
      end

      it 'persists the correct amount of data' do
        expect do
          subject.call
        end.to change(StarTrack, :count).by(2)
      end

      it 'records all repos' do
        subject.call

        item.each do |it|
          record = StarTrack.where(repository_name: it['name']).last

          expect(record).to_not be_nil
          expect(record.star_count).to eq(it['stargazers_count'])
        end
      end
    end
  end
end
