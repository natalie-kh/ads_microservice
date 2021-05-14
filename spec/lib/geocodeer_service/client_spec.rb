# frozen_string_literal: true

RSpec.describe GeocoderService::Client, type: :client do
  subject { described_class.new(connection: connection) }

  let(:status) { 200 }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:body) { {} }

  before do
    stubs.get('geocode') { [status, headers, body.to_json] }
  end

  describe '#geocode (valid city)' do
    let(:body) { { 'lat' => 55.7540471, 'lon' => 37.620405 } }

    it 'returns lon and lat' do
      expect(subject.geocode('valid.city')).to eq body
    end
  end

  describe '#geocode (invalid city)' do
    let(:status) { 404 }

    it 'returns nil' do
      expect(subject.geocode('invalid.city')).to be_nil
    end
  end

  describe '#geocode (nil city)' do
    let(:status) { 422 }

    it 'returns nil' do
      expect(subject.geocode(nil)).to be_nil
    end
  end
end
