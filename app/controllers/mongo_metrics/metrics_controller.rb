# This controller exposes the routes that let us see what notifications are being recorded in the database
module MongoMetrics
  class MetricsController < ApplicationController
    respond_to :html, :json
    respond_to :csv, only: :index

    def index
      @metrics = Metric.all
      respond_with(@metrics)
    end

    def destroy
      @metric = Metric.find params[:id]
      @metric.destroy
      respond_with(@metric)
    end
  end
end