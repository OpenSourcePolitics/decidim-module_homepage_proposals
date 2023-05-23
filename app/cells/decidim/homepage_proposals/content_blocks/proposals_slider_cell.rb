# frozen_string_literal: true

# frozen_string literal: true

module Decidim
  module HomepageProposals
    module ContentBlocks
      class ProposalsSliderCell < Decidim::ViewModel
        def glanced_proposals(category: nil, component: nil, scope: nil)
          return Decidim::Proposals::Proposal.where(component: content_block_settings.default_linked_component).sample(12) unless content_block_settings.activate_filters

          proposals = if component.present?
                        Decidim::Proposals::Proposal.where(component: component)
                      else
                        Decidim::Proposals::Proposal.where(component: content_block_settings.default_linked_component)
                      end
          proposals = proposals.where(category: category) if category.present?
          proposals = proposals.where(scope: scope) if scope.present?
          proposals.sample(12)
        end

        private

        def content_block_settings
          @content_block_settings ||= Decidim::ContentBlock.find_by(
            manifest_name: "proposals_slider",
            organization: current_organization
          ).settings
        end

        def linked_components
          @linked_components ||= Decidim::Component.where(id: content_block_settings.linkeds_component_id.reject(&:blank?).map(&:to_i))
        end
      end
    end
  end
end
