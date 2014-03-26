class SpecialEmailsController < ApplicationController
  # GET /special_emails
  # GET /special_emails.json

  before_filter :authenticate_user!
  before_filter :valid_users_only

  def index
    @special_emails = SpecialEmail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @special_emails }
    end
  end

  # GET /special_emails/1
  # GET /special_emails/1.json
  def show
    @special_email = SpecialEmail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @special_email }
    end
  end

  # GET /special_emails/new
  # GET /special_emails/new.json
  def new
    @special_email = SpecialEmail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @special_email }
    end
  end

  # GET /special_emails/1/edit
  def edit
    @special_email = SpecialEmail.find(params[:id])
  end

  # POST /special_emails
  # POST /special_emails.json
  def create
    @special_email = SpecialEmail.new(params[:special_email])

    respond_to do |format|
      if @special_email.save
        format.html { redirect_to @special_email, notice: 'Special email was successfully created.' }
        format.json { render json: @special_email, status: :created, location: @special_email }
      else
        format.html { render action: "new" }
        format.json { render json: @special_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /special_emails/1
  # PUT /special_emails/1.json
  def update
    @special_email = SpecialEmail.find(params[:id])

    respond_to do |format|
      if @special_email.update_attributes(params[:special_email])
        format.html { redirect_to @special_email, notice: 'Special email was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @special_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /special_emails/1
  # DELETE /special_emails/1.json
  def destroy
    @special_email = SpecialEmail.find(params[:id])
    @special_email.destroy

    respond_to do |format|
      format.html { redirect_to special_emails_url }
      format.json { head :no_content }
    end
  end

  private 

  def valid_users_only
    if !User::PRIVILEGED_EMAILS.include?( current_user.email ) 
      raise ActiveRecord::RecordNotFound, "Page not found"
    end
  end
end
