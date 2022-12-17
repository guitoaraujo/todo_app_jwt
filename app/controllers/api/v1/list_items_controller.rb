class Api::V1::ListItemsController < Api::V1::ApiController
  before_action :set_list, only: %i[index create update destroy]
  before_action :set_list_item, only: %i[update destroy]

  def index
    list_items = @list.list_items.where.not(completion_status: :deleted)

    render json: { list_items: list_items }, status: :ok
  end

  def create
    @list_item = ListItem.create(list_item_params)

    if @list_item.valid?
      response_ok
    else
      response_unprocessable_entity
    end
  end

  def update
    if @list_item.update(list_item_params)
      response_ok
    else
      response_unprocessable_entity
    end
  end

  def destroy
    if @list_item.deleted!
      response_ok
    else
      response_unprocessable_entity
    end
  end

  private

  def list_item_params
    params.permit(:completion_status, :short_name, :description).merge(list: @list)
  end

  def set_list
    @list = List.find(params[:list_id])

    render json: { errors: 'Unauthorized!' }, status: :unauthorized if @list.user != @user
    render json: { errors: 'Not found!' }, status: :not_found if @list.deleted?
  end

  def set_list_item
    @list_item = ListItem.find(params[:id])

    render json: { errors: 'Not found!' }, status: :not_found if @list_item.deleted?
  end

  def response_ok
    render json: { list_item: @list_item }, status: :ok
  end

  def response_unprocessable_entity
    render json: { errors: @list_item.errors.messages }, status: :unprocessable_entity
  end
end
