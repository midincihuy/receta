require 'spec_helper'

describe RecipesController do
  render_views
  describe "GET 'index'" do
  	before do
      Recipe.create!(name: 'Baked Potato w/ Cheese', instructions: "ini instructions")
      Recipe.create!(name: 'Garlic Mashed Potatoes', instructions: "ini instructions")
      Recipe.create!(name: 'Potatoes Au Gratin', instructions: "ini instructions")
      Recipe.create!(name: 'Baked Brussel Sprouts', instructions: "ini instructions")
      xhr :get, :index, :format => "json", :keywords => keywords
    end

    subject(:results) { 
    	response.body && response.body.length >= 2 ? JSON.parse(response.body) : nil
    }

    def extract_name
    	->(object) {object["name"]}
    end

    context "when the search finds THE RESULTS" do
    	let(:keywords ) { 'baked' }
      let(:format) {'json'}
    	
    	it 'should 200 DONK' do
    		expect(response.status).to eq(200)
    	end

    	it 'should return two results' do
    		expect(results.size).to eq(2)
    	end
      
      it "should include 'Baked Potato w/ Cheese'" do
        expect(results.map(&extract_name)).to include('Baked Potato w/ Cheese')
      end
      it "should include 'Baked Brussel Sprouts'" do
        expect(results.map(&extract_name)).to include('Baked Brussel Sprouts')
      end
    end

    context "when the search DOES NOT find the results" do
    	let(:keywords) { 'foo' }
      let(:format) {'json'}
    	it 'should return no results' do
    		expect(results.size).to eq(0)
    	end

    end

  end

end
