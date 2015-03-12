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


  describe "show" do
    before do
      xhr :get, :show, format: :json, id: recipe_id
    end

    subject(:results) { JSON.parse(response.body) }

    context "when the recipe exists" do
      let(:recipe) { 
        Recipe.create!(name: 'Baked Potato w/ Cheese', 
               instructions: "Nuke for 20 minutes; top with cheese") 
      }
      let(:recipe_id) { recipe.id }

      it { expect(response.status).to eq(200) }
      it { expect(results["id"]).to eq(recipe.id) }
      it { expect(results["name"]).to eq(recipe.name) }
      it { expect(results["instructions"]).to eq(recipe.instructions) }
    end

    context "when the recipe doesn't exit" do
      let(:recipe_id) { -9999 }
      it { expect(response.status).to eq(404) }
    end
  end

  describe "create" do
    before do
      xhr :post, :create, format: :json, recipe: { name: "Toast", 
                                           instructions: "Add bread to toaster, push lever" }
    end
    it { expect(response.status).to eq(201) }
    it { expect(Recipe.last.name).to eq("Toast") }
    it { expect(Recipe.last.instructions).to eq("Add bread to toaster, push lever") }
  end

  describe "update" do
    let(:recipe) { 
      Recipe.create!(name: 'Baked Potato w/ Cheese', 
                     instructions: "Nuke for 20 minutes; top with cheese") 
    }
    before do
      xhr :put, :update, format: :json, id: recipe.id, recipe: { name: "Toast", 
                                                 instructions: "Add bread to toaster, push lever" }
      recipe.reload
    end
    it { expect(response.status).to eq(204) }
    it { expect(recipe.name).to eq("Toast") }
    it { expect(recipe.instructions).to eq("Add bread to toaster, push lever") }
  end

  describe "destroy" do
    let(:recipe_id) { 
      Recipe.create!(name: 'Baked Potato w/ Cheese', 
                     instructions: "Nuke for 20 minutes; top with cheese").id
    }
    before do
      xhr :delete, :destroy, format: :json, id: recipe_id
    end
    it { expect(response.status).to eq(204) }
    it { expect(Recipe.find_by_id(recipe_id)).to be_nil }
  end
end
