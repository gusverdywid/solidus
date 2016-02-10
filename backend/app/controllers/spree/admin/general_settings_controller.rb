module Spree
  module Admin
    class GeneralSettingsController < Spree::Admin::BaseController
      include Spree::Backend::Callbacks

      before_action :set_store

      def edit
      end

      def update
        current_store.update_attributes store_params

        flash[:success] = Spree.t(:successfully_updated, resource: Spree.t(:general_settings))
        redirect_to edit_admin_general_settings_path
      end

      def clear_cache
        Rails.cache.clear
        invoke_callbacks(:clear_cache, :after)
        head :no_content
      end

      private

      def store_params
        params.require(:store).permit(permitted_params)
      end

      def permitted_params
        Spree::PermittedAttributes.store_attributes
      end

      def set_store
        @store = current_store
      end
    end
  end
end
