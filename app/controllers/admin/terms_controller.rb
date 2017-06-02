# frozen_string_literal: true

class Admin::TermsController < Comfy::Admin::Cms::BaseController
  before_action :set_term, only: %i[show edit update destroy]

  # GET /terms
  def index
    @terms = Term.all
  end

  # GET /terms/1
  def show; end

  # GET /terms/new
  def new
    @term = Term.new
  end

  # GET /terms/1/edit
  def edit; end

  # POST /terms
  def create
    if current_user.admin? || current_user.super_user?
      @term = Term.new(term_params)

      if @term.save
        redirect_to [:admin, @term], notice: 'Term was successfully created.'
      else
        render :new, notice: "Term could not be created due to the following error(s): " +
                             "#{@term.errors.full_messages.join(". ")}"
      end
    else
      render :index, notice: 'Only admins can create a term.'
    end
  end

  # PATCH/PUT /terms/1
  def update
    if current_user.admin? || current_user.super_user?
      if @term.update(term_params)
        redirect_to [:admin, @term], notice: 'Term was successfully updated.'
      else
        render :edit, notice: "Term could not be updated due to the following error(s): " +
                             "#{@term.errors.full_messages.join(". ")}"
      end
    else
      render :index, notice: 'Only admins can create a term.'
    end
  end

  # DELETE /terms/1
  def destroy
    @term.destroy
    redirect_to admin_terms_url, notice: 'Term was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_term
    @term = Term.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def term_params
    params.require(:term).permit(:name)
  end
end
