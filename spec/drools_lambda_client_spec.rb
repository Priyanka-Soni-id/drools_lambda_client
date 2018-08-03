require "json"
require "spec_helper"

RSpec.describe DroolsLambdaClient do

  it "has a version number" do
    expect(DroolsLambdaClient::VERSION).not_to be nil
  end

  describe 'execute!' do

    let(:user_attributes) {{id: 1}}
    let(:rp1_attributes) {{house_id: 1, amount: 1000, bank_detail_id: 12, profile_id: 1}}
    let(:rp2_attributes) {{house_id: 1, amount: 500, bank_detail_id: 12, profile_id: 1}}

    let(:response_hash) {
      {
          "namespace" => [{"name" => '1234'}],
          "action" => [{"name" => ""}],
          "additionalParams" => [{"rpId" => 1}],
          "user"=>[{"id" => 1, "profileId" => 1, "currentUser" => true, "relationshipType" => "tenant"}]
      }
    }

    let(:expected_response) {
      {
          namespace: [{
                          name: '1234'
                      }],
          action: [{
                       name: ""
                   }],
          additional_params: [{
                                  rp_id: 1
                              }],
          user: [{
                     id: 1,
                     profile_id: 1,
                     current_user: true,
                     relationship_type: "tenant"
                 }]
      }
    }

    it 'should return data_hash' do
      data_hash = {
          "user" => [user_attributes],
          "receivable_payable" => [rp1_attributes, rp2_attributes]
      }

      expect(LambdaClient).to receive_message_chain(:invoke, :payload, :read).and_return(response_hash.to_json)
      response = DroolsLambdaClient.execute!(data_hash: data_hash, namespace: '1234', lambda_function: 'abcd')
      expect(response).to eq expected_response
    end

    it 'should convert single object to array and execute' do
      data_hash = {
          "user" => user_attributes,
          "receivable_payable" => [rp1_attributes, rp2_attributes]
      }

      expect(LambdaClient).to receive_message_chain(:invoke, :payload, :read).and_return(response_hash.to_json)
      response = DroolsLambdaClient.execute!(data_hash: data_hash, namespace: '1234', lambda_function: 'abcd')
      expect(response).to eq expected_response
    end

  end


end
