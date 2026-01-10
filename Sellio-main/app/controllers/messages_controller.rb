class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:show]

  # GET /messages
  def index
    @messages = Message.where("sender_id = ? OR recipient_id = ?", current_user.id, current_user.id)
                       .order(created_at: :desc)
  end

  # GET /my_messages
  def my_messages
    @received_messages = Message.where(recipient_id: current_user.id)
                                .includes(:sender, :listing)
                                .order(created_at: :desc)
    @sent_messages = Message.where(sender_id: current_user.id)
                           .includes(:recipient, :listing)
                           .order(created_at: :desc)
  end

  # GET /messages/1
  def show
    # Mark as read if current user is the recipient
    if @message.recipient == current_user && !@message.read?
      @message.update(read: true)
    end
  end

  # GET /messages/new
  def new
    @message = Message.new
    @listing = Listing.find(params[:listing_id]) if params[:listing_id]
  end

  # POST /messages
  def create
    @message = Message.new(message_params)
    @message.sender = current_user

    respond_to do |format|
      if @message.save
        format.html { redirect_to my_messages_path, notice: "Message sent successfully." }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_message
    @message = Message.find(params[:id])
    # Ensure user can only see their own messages
    unless @message.sender == current_user || @message.recipient == current_user
      redirect_to my_messages_path, alert: "You don't have permission to view this message."
    end
  end

  def message_params
    params.require(:message).permit(:listing_id, :recipient_id, :content)
  end
end
