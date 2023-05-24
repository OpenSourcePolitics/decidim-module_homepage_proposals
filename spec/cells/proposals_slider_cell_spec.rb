# frozen_string_literal: true

require "spec_helper"

module Decidim
  module HomepageProposals
    module ContentBlocks
      describe ProposalsSliderCell, type: :cell do
        subject { cell("decidim/homepage_proposals/content_blocks/proposals_slider") }

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
          allow(subject).to receive(:current_organization).and_return(current_organization)
        end

        context "when there are no proposals component" do
          it "renders nothing" do
            expect(subject.glanced_proposals).to be_empty
          end
        end

        context "when there is a proposal component " do
          let!(:component) { create(:proposal_component, organization: current_organization) }
          let!(:proposals) { create_list(:proposal, 12, component: component) }

          context "and it's not linked" do
            it "renders nothing" do
              expect(subject.glanced_proposals).to be_empty
            end
          end

          context "and it's linked" do
            let!(:linked_components_id) { [component.id] }
            let!(:default_linked_component) { component.id }

            it "renders proposals of this component" do
              expect(subject.glanced_proposals).to match_array(proposals)
            end
          end
        end

        context "when there are multiple proposal components" do
          let!(:component) { create(:proposal_component, organization: current_organization) }
          let!(:component2) { create(:proposal_component, organization: current_organization) }
          let!(:proposals) { create_list(:proposal, 12, component: component) }
          let!(:proposals2) { create_list(:proposal, 12, component: component2) }

          context "and only one is linked" do
            let!(:linked_components_id) { [component2.id] }
            let!(:default_linked_component) { component2.id }

            it "renders proposals of this component" do
              expect(subject.glanced_proposals).to match_array(proposals2)
            end
          end

          context "and multiple are linked" do
            let!(:linked_components_id) { [component.id, component2.id] }
            let!(:default_linked_component) { component.id }

            it "renders proposals of the default component" do
              expect(subject.glanced_proposals).to match_array(proposals)
            end
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

          let!(:linked_components_id) { [default_component.id, component.id] }
          let!(:default_linked_component) { default_component.id }

          context "when filters are not activated" do
            it "renders proposals of the default component" do
              expect(subject.glanced_proposals(component: component)).to match_array(default_proposals)
            end
          end

          context "when filters are activated" do
            let!(:activate_filters) { true }

            context "when there are no filters" do
              it "renders proposals of the default component" do
                expect(subject.glanced_proposals).to match_array(default_proposals)
              end
            end

            context "when there is a filter on the component" do
              it "renders proposals of the asked component" do
                expect(subject.glanced_proposals(component: component)).to match_array(proposals_11 + proposals_12 + proposals_21 + proposals_22 + proposals_31 + proposals_32)
              end

              context "and on the category" do
                it "renders proposals of the asked category" do
                  expect(subject.glanced_proposals(component: component, category: category2)).to match_array(proposals_21 + proposals_22)
                end
              end

              context "and on the scope" do
                it "renders proposals of the asked scope" do
                  expect(subject.glanced_proposals(component: component, scope: scope2)).to match_array(proposals_12 + proposals_22 + proposals_32)
                end
              end

              context "and on the category and the scope" do
                it "renders proposals of the asked category and scope" do
                  expect(subject.glanced_proposals(component: component, category: category2, scope: scope2)).to match_array(proposals_22)
                end
              end
            end
          end
        end
      end
    end
  end
end
