class FilesController < ApplicationController
  def index
    @file_names = AccountData.index
  end

  def show
    @account_data = AccountData.find(params[:id])
  end
end
