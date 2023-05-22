# frozen_string_literal: true

module Decidim
  module HomepageProposals
    module ContentBlocks
      class ProposalsSliderSettingsFormCell < Decidim::ViewModel
        include ActionView::Helpers::FormOptionsHelper

        alias form model

        def content_block
          options[:content_block]
        end

        def options_for_proposals_components
          options = proposals_components.map do |proposal_component|
            ["#{translated_attribute(proposal_component.name)} (#{translated_attribute(proposal_component.participatory_space.title)})", proposal_component.id]
          end
          options_for_select(options, selected: content_block.settings.linked_component_id)
        end

        def proposals_components
          @proposals_components ||= Decidim::Component.where(manifest_name: "proposals")
        end
      end
    end
  end
end
