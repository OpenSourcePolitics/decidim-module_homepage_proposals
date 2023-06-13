# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe ProposalsSliderController, type: :controller do
    let!(:current_organization) { create(:organization) }
    let!(:activate_filters) { false }
    let!(:linked_components_id) { [] }
    let!(:default_linked_component) { nil }
    let!(:content_block) do
      create(:content_block,
             manifest_name: "proposals_slider",
             organization: current_organization,
             settings: { activate_filters: activate_filters,
                         linked_components_id: linked_components_id,
                         default_linked_component: default_linked_component })
    end

    before do
      request.env["decidim.current_organization"] = current_organization
    end

    describe "POST refresh_proposals" do
      context "when there are no proposals component" do
        it "renders the organization url" do
          post "refresh_proposals", params: { filter: { component_id: "", category_id: "", scope_id: "" } }

          expect(JSON.parse(response.body)).to eq({ "url" => "/" })
        end
      end

      context "when there is a proposal component " do
        let!(:component) { create(:proposal_component, organization: current_organization) }
        let!(:proposals) { create_list(:proposal, 12, component: component) }

        it "renders proposals of this component" do
          post "refresh_proposals", params: { filter: { component_id: component.id, category_id: "", scope_id: "" } }

          expect(JSON.parse(response.body).size).to eq(12)
          expect(JSON.parse(response.body).map { |proposal| proposal["id"] }).to match_array((proposals).map(&:id))
        end
      end

      context "when there is arguments" do
        let!(:default_component) { create(:proposal_component, organization: current_organization) }
        let!(:default_proposals) { create_list(:proposal, 12, component: default_component) }
        let!(:component) { create(:proposal_component, organization: current_organization) }
        let!(:category1) { create(:category, participatory_space: component.participatory_space) }
        let!(:category2) { create(:category, participatory_space: component.participatory_space) }
        let!(:category3) { create(:category, participatory_space: component.participatory_space) }
        let!(:scope1) { create(:scope, organization: current_organization) }
        let!(:scope2) { create(:scope, organization: current_organization) }
        let!(:proposals_11) { create_list(:proposal, 2, component: component, category: category1, scope: scope1) }
        let!(:proposals_12) { create_list(:proposal, 2, component: component, category: category1, scope: scope2) }
        let!(:proposals_21) { create_list(:proposal, 2, component: component, category: category2, scope: scope1) }
        let!(:proposals_22) { create_list(:proposal, 2, component: component, category: category2, scope: scope2) }
        let!(:proposals_31) { create_list(:proposal, 2, component: component, category: category3, scope: scope1) }
        let!(:proposals_32) { create_list(:proposal, 2, component: component, category: category3, scope: scope2) }
        let!(:proposals) { proposals_11 + proposals_12 + proposals_21 + proposals_22 + proposals_31 + proposals_32 }

        context "when there is a filter on the component" do
          it "renders proposals of the asked component" do
            post "refresh_proposals", params: { filter: { component_id: component.id, category_id: "", scope_id: "" } }

            expect(JSON.parse(response.body).size).to eq(12)
            expect(JSON.parse(response.body).map { |proposal| proposal["id"] }).to match_array(proposals.map(&:id))
          end

          context "and on the category" do
            it "renders proposals of the asked category" do
              post "refresh_proposals", params: { filter: { component_id: component.id, category_id: category1.id, scope_id: "" } }

              expect(JSON.parse(response.body).size).to eq(4)
              expect(JSON.parse(response.body).map { |proposal| proposal["id"] }).to match_array((proposals_11 + proposals_12).map(&:id))
            end
          end

          context "and on the scope" do
            it "renders proposals of the asked scope" do
              post "refresh_proposals", params: { filter: { component_id: component.id, category_id: "", scope_id: scope1.id } }

              expect(JSON.parse(response.body).size).to eq(6)
              expect(JSON.parse(response.body).map { |proposal| proposal["id"] }).to match_array((proposals_11 + proposals_21 + proposals_31).map(&:id))
            end
          end

          context "and on the category and the scope" do
            it "renders proposals of the asked category and scope" do
              post "refresh_proposals", params: { filter: { component_id: component.id, category_id: category3.id, scope_id: scope2.id } }

              expect(JSON.parse(response.body).size).to eq(2)
              expect(JSON.parse(response.body).map { |proposal| proposal["id"] }).to match_array((proposals_32).map(&:id))
            end
          end
        end
      end
    end
  end
end
