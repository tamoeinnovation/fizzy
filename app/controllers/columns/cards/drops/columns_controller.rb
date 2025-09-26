class Columns::Cards::Drops::ColumnsController < ApplicationController
  include ActionView::RecordIdentifier, CardScoped

  def create
    column = @card.collection.columns.find(params[:column_id])
    @card.triage_into(column)

    render turbo_stream: turbo_stream.replace(dom_id(column), partial: "collections/show/column", locals: { column: column })
  end
end
