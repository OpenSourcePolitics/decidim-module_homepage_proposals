# frozen_string_literal: true

namespace :decidim do
  namespace :homepage_proposals do
    desc "Seed module"
    task seed: :environment do
      organization = Decidim::Organization.first

      components = Decidim::Component.where(manifest_name: "proposals").where.not(participatory_space: nil)

      Decidim::ContentBlock.create(
        decidim_organization_id: organization.id,
        weight: 1,
        scope_name: :homepage,
        manifest_name: :proposals_slider,
        published_at: Time.current,
        settings: {
          activate_filters: true,
          linked_components_id: [components.first.id, components.second.id],
          default_linked_component: components.first.id
        }
      )
    end
  end
end
