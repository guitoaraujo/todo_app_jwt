class Api::V1::ListsController < Api::V1::ApiController
  skip_before_action :authorize, only: %i[index]
  before_action :set_list, only: %i[update destroy]

  def index
    lists = List.with_list_items

    render json: { lists: lists }, status: :ok
  end

  def create
    @list = List.create(list_params)

    if @list.valid?
      response_ok
    else
      response_unprocessable_entity
    end
  end

  def update
    if @list.update(list_params)
      response_ok
    else
      response_unprocessable_entity
    end
  end

  def destroy
    if @list.deleted!
      response_ok
    else
      response_unprocessable_entity
    end
  end

  private

  def list_params
    params.permit(:status, :name).merge(user: @user)
  end

  def set_list
    @list = List.find(params[:id])

    render json: { errors: 'Unauthorized!' }, status: :unauthorized if @list.user != @user
    render json: { errors: 'Not found!' }, status: :not_found if @list.deleted?
  end

  def response_ok
    render json: { list: @list }, status: :ok
  end

  def response_unprocessable_entity
    render json: { errors: @list.errors.messages }, status: :unprocessable_entity
  end
end
