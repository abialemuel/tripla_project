class UsersController < ApplicationController
  before_action :authenticate_request, except: [ :index, :show, :clocked_in_times ]

  # GET /users
  def index
    users = User.all
    render json: users
  end

  # GET /users/:id
  def show
    user = User.find(params[:id])
    render json: user
  end

  # POST /users/:id/follow
  def follow
    user = User.find(params[:id])

    if current_user.following?(user)
      render json: { error: "Already following this user" }, status: :unprocessable_entity
    else
      current_user.follow(user)
      render json: { message: "You are now following #{user.name}" }, status: :ok
    end
  end

  # DELETE /users/:id/unfollow
  def unfollow
    user = User.find(params[:id])

    if current_user.following?(user)
      current_user.unfollow(user)
      render json: { message: "You have unfollowed #{user.name}" }, status: :ok
    else
      render json: { error: "You are not following this user" }, status: :unprocessable_entity
    end
  end

  # GET /users/following_sleep_records
  def following_sleep_records
    sleeps = Sleep.joins(:user)
                  .where(user_id: User.select(:id).where(id: current_user.following))
                  .where("clock_in >= ?", 1.week.ago)
                  .order(Arel.sql("clock_out - clock_in DESC, clock_in DESC"))
                  .limit(100)
    render json: sleeps
  end

  # POST /users/clock_in
  def clock_in
    ActiveRecord::Base.transaction do
      current_user.lock!  # Lock the user to prevent concurrent clock-ins

      if current_user.sleeps.where(clock_out: nil).exists?
        render json: { error: "You have an active sleep record. Clock out first." }, status: :unprocessable_entity
        return
      end

      sleep_record = current_user.sleeps.create(clock_in: Time.current)

      if sleep_record.persisted?
        render json: sleep_record, serializer: SleepSerializer, status: :created
      else
        render json: { error: sleep_record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  # POST /users/clock_out
  def clock_out
    # Lock the record to prevent race conditions
    sleep_record = current_user.sleeps.where(clock_out: nil).order(clock_in: :desc).lock("FOR UPDATE").first

    if sleep_record
      sleep_record.update(clock_out: Time.current)
      render json: sleep_record, serializer: SleepSerializer, status: :ok
    else
      render json: { error: "No active sleep record found" }, status: :unprocessable_entity
    end
  end

  # GET /users/clocked_in_times
  def clocked_in_times
    records = Sleep.order(created_at: :desc)  # Fetch all sleep records
    render json: records, each_serializer: SleepSerializer, status: :ok
  end
end
