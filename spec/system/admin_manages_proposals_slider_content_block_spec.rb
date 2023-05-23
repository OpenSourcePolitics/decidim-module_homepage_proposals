# frozen_string_literal: true

require "spec_helper"

describe "Admin manages proposals slider content blocks", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  context "when trying to editate content blocks" do
    it "shows the proposals slider one" do
      visit decidim_admin.edit_organization_homepage_path

      within ".js-list-availables" do
        expect(page).to have_content("Proposals slider")
      end
    end

    context "when editing a persisted content block" do
      let!(:content_block) { create :content_block, organization: organization, manifest_name: :proposals_slider, scope_name: :homepage }
      let!(:proposals_component1) { create :component, manifest_name: "proposals" }
      let!(:proposals_component2) { create :component, manifest_name: "proposals" }
      let!(:proposals_component3) { create :component, manifest_name: "proposals" }
      let!(:proposals_component4) { create :component }

      it "updates the settings of the content block" do
        visit decidim_admin.edit_organization_homepage_content_block_path(:proposals_slider)

        check "Activate filters"

        within "select[label='Linked components']" do
          find("option[value='#{proposals_component1.id}']").click
          find("option[value='#{proposals_component3.id}']").click
          expect(page).not_to have_css("option[value='#{proposals_component4.id}']")
        end

        click_button "Update"

        expect(content_block.reload.settings.activate_filters).to eq(true)
        expect(content_block.reload.settings.linked_component_id).to eq(["", proposals_component1.id.to_s, proposals_component3.id.to_s])

        visit decidim.root_path

        expect(page).to have_content("EXPLORE PROPOSALS")
      end
    end
  end
end
