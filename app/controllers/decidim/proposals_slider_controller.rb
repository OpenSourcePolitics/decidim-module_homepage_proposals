# frozen_string_literal: true

module Decidim
  class ProposalsSliderController < Decidim::ApplicationController
    include Decidim::FilterResource
    include Decidim::TranslatableAttributes
    include Decidim::Core::Engine.routes.url_helpers

    def refresh_proposals
      render json: build_proposals_api
    end

    private

    def build_proposals_api
      glanced_proposals.flat_map do |proposal|
        {
          id: proposal.id,
          title: translated_attribute(proposal.title).truncate(40),
          body: translated_attribute(proposal.body).truncate(150),
          url: proposal_path(proposal),
          image: image_for(proposal),
          state: proposal.state
        }
      end
    end

    def glanced_proposals
      if params[:filter].present?
        category = Decidim::Category.find(params.dig(:filter, :category_id)) if params.dig(:filter, :category_id).present?
        scopes = Decidim::Scope.find(params.dig(:filter, :scope_id)) if params.dig(:filter, :scope_id).present?
      end

      @glanced_proposals ||= Decidim::Proposals::Proposal.published
                                                         .where(component: params.dig(:filter, :component_id))
                                                         .where(filter_by_scopes(scopes))
                                                         .select do |proposal|
                                                           if category.present?
                                                             proposal.category == category
                                                           else
                                                             true
                                                           end
                                                         end
                                                         .sample(12)
    end

    def filter_by_scopes(scopes)
      { scope: scopes } if scopes.present?
    end

    def proposal_path(proposal)
      Decidim::ResourceLocatorPresenter.new(proposal).path
    end

    def image_for(proposal)
      return view_context.image_pack_url("media/images/slider_proposal_image.jpeg") unless proposal.attachments.select(&:image?).any?

      proposal.attachments.select(&:image?).first&.url
    end
  end
end
