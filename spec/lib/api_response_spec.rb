require 'spec_helper'

include RequestSpecHelper

describe Suretax::Api::Response do

  let(:api_response) { Suretax::Api::Response.new(response_body) }

  context 'with a successful response' do

    let(:response_body) { valid_test_response_body }

    describe '#status' do
      it 'should return the API status code' do
        expect(api_response.status).to eql('9999')
      end
    end

    describe '#success?' do
      it 'should be true' do
        expect(api_response.success?).to be_true
      end
    end


    describe '#message' do
      it 'should be "Success"' do
        expect(api_response.message).to eql('Success')
      end
    end

    describe '#total_tax' do
      let(:params) {
        {
          amount: 1394490,
          precision: 6,
          divisor: 1000000
        }
      }

      it 'should have the correct tax amount' do
        expect(api_response.total_tax.to_f).to eql(1.394490)
        expect(api_response.total_tax.to_s).to eql('1.394490')
        expect(api_response.total_tax.to_i).to eql(1394490)
        expect(api_response.total_tax.total_cents).to eql(139)
        expect(api_response.total_tax.precision).to eql(6)
        expect(api_response.total_tax.params).to eql(params)
      end
    end
  end

  context 'with a partially successful response' do

    let(:response_body) { success_with_item_errors }

    describe '#status' do
      it 'should return the API status code' do
        expect(api_response.status).to eql('9001')
      end
    end

    describe '#success?' do
      it 'should be true' do
        expect(api_response.success?).to be_true
      end
    end

    describe '#message' do
      it 'should start with "Failure"' do
        expect(api_response.message).to match(/\ASuccess with item errors/i)
      end
    end
  end

  context 'with a failure response' do

    let(:response_body) { valid_failure_response }

    describe '#status' do
      it 'should return the API status code' do
        expect(api_response.status).to eql('1101')
      end
    end

    describe '#success?' do
      it 'should be false' do
        expect(api_response.success?).to be_false
      end
    end

    describe '#message' do
      it 'should start with "Failure"' do
        expect(api_response.message).to match(/\AFailure/)
      end
    end
  end
end
