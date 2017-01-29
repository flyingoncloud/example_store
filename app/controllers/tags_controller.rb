class TagsController < ApplicationController
  before_action :set_knowledge_point, only: [:show, :edit, :update, :destroy]

  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
  end

  # GET /tags/all_children
  def all_children
    parent_id = params[:id]
    Rails.logger.info("Selected parent:" + parent_id)
    if parent_id.present? then
      @all_second_children = Tag.all_children(parent_id)
    end

    Rails.logger.info("Found children:  #{@all_second_children.length}")

    respond_to do |format|
      format.html { redirect_to knowledge_points_url, notice: 'Knowledge points were successfully created.' }
      format.json { render json: @all_second_children }
    end

  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @tag = Tag.new
    @all_children = Tag.all_children(-1)
    @all_second_children = []

  end

  # GET /tags/1/edit
  def edit

  end

  # POST /tags
  # POST /tags.json
  def create
    create_tags(params)

    respond_to do |format|
      format.html { redirect_to tags_url, notice: 'Tags were successfully created.' }
      format.json { head :no_content }
    end
  end


  def add_children
    respond_to do |format|
      format.html { redirect_to tags_url, notice: 'Tags were successfully created.' }
      format.json { head :no_content }
    end
  end



  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    children = Tag.all_children(@tag.id)
    if children.empty?
      @tag.destroy
      respond_to do |format|
        format.html { redirect_to knowledge_points_url, notice: 'Tag was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to knowledge_points_url, notice: 'Tag has children. Cannot be destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_knowledge_point
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:tag_indexes, :parent_id, :parent_level)
    end

    def print_tag (tag)
      Rails.logger.info("*********")
      Rails.logger.info("name: #{tag.name}")
      Rails.logger.info("alias: #{tag.alias}")
      Rails.logger.info("parent_id: #{tag.parent_id}")
      Rails.logger.info("parent_name: #{tag.parent_name}")
      Rails.logger.info("memo: #{tag.memo}")

    end

    def create_tags(params)
      tag_indexes = params["tag"]["tag_indexes"]
      parent_id = 0
      parent_level = 0
      parent_id = params["tag"]["parent_id"].to_i if params["tag"]["parent_id"]
      parent_level = params["tag"]["parent_level"].to_i if params["tag"]["parent_level"]

      if tag_indexes.strip().length > 0
        indexes = tag_indexes.split(" ")
        indexes.each do |index|
          index = index.strip()
          tag = Tag.new()
          tag.name = params["tag_name_" + index].strip()
          tag.alias = params["tag_alias_text_" + index].strip()
          tag.parent_id = parent_id
          tag.parent_level = parent_level

          print_tag(tag)

          tag.save

        end
      end
    end
end
