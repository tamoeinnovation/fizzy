class Buckets::ViewsController < ApplicationController
  include BucketScoped

  def create
    @bucket_view = @bucket.views.create! filters: filter_params
    redirect_to bucket_bubbles_path(@bucket, **filter_params), notice: "✓"
  end

  def update
    @bucket_view.update! filters: filter_params
    redirect_to bucket_bubbles_path(@bucket, **filter_params), notice: "✓"
  end

  def destroy
    @bucket_view.destroy
    redirect_to bucket_bubbles_path(@bucket, **filter_params), notice: "✓"
  end

  private
    def filter_params
      helpers.bubble_filter_params.to_h.compact_blank
    end
end
