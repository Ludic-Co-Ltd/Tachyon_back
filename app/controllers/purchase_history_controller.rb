require 'prawn'
# require 'prawn-table'
require 'prawn/measurement_extensions'

class PurchaseHistoryController < ApplicationController
  before_action :set_purchase_history, only: %i[ show update destroy ] 

  # GET /purchase_histories
  def index
    @purchase_histories = PurchaseHistory.all

    render json: @purchase_histories
  end

  # GET /purchase_histories/1
  def show
    render json: @purchase_history
  end

  # POST /purchase_histories
  def create
    @purchase_history = PurchaseHistory.new(purchase_history_params)

    if @purchase_history.save
      render json: @purchase_history, status: 200, location: @purchase_history
    else
      render json: @purchase_history.errors, status: 422
    end
  end

  # PATCH/PUT /purchase_histories/1
  def update
    if @purchase_history.update(purchase_history_params)
      render json: @purchase_history
    else
      render json: @purchase_history.errors, status: 422
    end
  end

  # DELETE /purchase_histories/1
  def destroy
    @purchase_history.destroy!
  end

  def download_pdf

    pdf_filename = "generated_file.pdf"

    Prawn::Document.generate(pdf_filename, encoding: "UTF-8") do
      font_families.update(
        "IPAPMincho" => {
          normal: "public/fonts/IPAMincho_Regular.ttf",
          # italic: "path_to_IPA_Mincho_Italic.ttf",
          # bold: "path_to_IPA_Mincho_Bold.ttf",
          # bold_italic: "path_to_IPA_Mincho_Bold_Italic.ttf"
        }
      )
      table_data = [
        ["ユーザー名", "Age", "Gender"],
        ["黒木凜", 30, "Male"],
        ["黒木凜", 25, "Female"],
        # Add more rows as needed
      ]
      font("IPAPMincho") do
        table(table_data, header: true, width: bounds.width) do
          row(0).style(background_color: 'cccccc', text_color: 'ffffff')
          columns(1..2).align = :center
          self.row_colors = ['DDDDDD', 'FFFFFF']
          self.header = true
        end
      end
    end

    send_file pdf_filename, type: "application/pdf", disposition: "attachment"
    # render json:'success'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase_history
      @purchase_history = PurchaseHistory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def purchase_history_params
      # params.fetch(:user, {})
      params.require(:purchase_history).permit!
    end
end
