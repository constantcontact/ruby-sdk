#
# library_service_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Services::LibraryService do
  describe "#get_library_info" do
    it "retrieves a MyLibrary usage information" do
      json_response = load_file('library_info_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      info = ConstantContact::Services::LibraryService.get_library_info()
      info.should be_kind_of(ConstantContact::Components::LibrarySummary)
      info.usage_summary['folder_count'].should eq(6)
    end
  end

  describe "#get_library_folders" do
    it "retrieves a list of MyLibrary folders" do
      json_response = load_file('library_folders_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      folders = ConstantContact::Services::LibraryService.get_library_folders({:limit => 2})
      folders.should be_kind_of(ConstantContact::Components::ResultSet)
      folders.results.first.should be_kind_of(ConstantContact::Components::LibraryFolder)
      folders.results.first.name.should eq('backgrounds')
    end
  end

  describe "#add_library_folder" do
    it "creates a new MyLibrary folder" do
      json = load_file('library_folder_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:post).and_return(response)
      new_folder = ConstantContact::Components::LibraryFolder.create(JSON.parse(json))

      folder = ConstantContact::Services::LibraryService.add_library_folder(new_folder)
      folder.should be_kind_of(ConstantContact::Components::LibraryFolder)
      folder.name.should eq('wildflowers')
    end
  end

  describe "#get_library_folder" do
    it "retrieves a specific MyLibrary folder using the folder_id path parameter" do
      json = load_file('library_folder_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      folder = ConstantContact::Services::LibraryService.get_library_folder(6)
      folder.should be_kind_of(ConstantContact::Components::LibraryFolder)
      folder.name.should eq('wildflowers')
    end
  end

  describe "#update_library_folder" do
    it "retrieves a specific MyLibrary folder using the folder_id path parameter" do
      json = load_file('library_folder_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:put).and_return(response)
      folder = ConstantContact::Components::LibraryFolder.create(JSON.parse(json))

      response = ConstantContact::Services::LibraryService.update_library_folder(folder)
      response.should be_kind_of(ConstantContact::Components::LibraryFolder)
      response.name.should eq('wildflowers')
    end
  end

  describe "#delete_library_folder" do
    it "deletes a MyLibrary folder" do
      folder_id = 6
      net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

      response = RestClient::Response.create('', net_http_resp, {})
      RestClient.stub(:delete).and_return(response)

      result = ConstantContact::Services::LibraryService.delete_library_folder(folder_id)
      result.should be_true
    end
  end

  describe "#get_library_trash" do
    it "retrieve all files in the Trash folder" do
      json = load_file('library_trash_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      files = ConstantContact::Services::LibraryService.get_library_trash({:sort_by => 'SIZE_DESC'})
      files.should be_kind_of(ConstantContact::Components::ResultSet)
      files.results.first.should be_kind_of(ConstantContact::Components::LibraryFile)
      files.results.first.name.should eq('menu_form.pdf')
    end
  end

  describe "#delete_library_trash" do
    it "permanently deletes all files in the Trash folder" do
      net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

      response = RestClient::Response.create('', net_http_resp, {})
      RestClient.stub(:delete).and_return(response)

      result = ConstantContact::Services::LibraryService.delete_library_trash()
      result.should be_true
    end
  end

  describe "#get_library_files" do
    it "retrieves a collection of MyLibrary files in the Constant Contact account" do
      json_response = load_file('library_files_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      files = ConstantContact::Services::LibraryService.get_library_files({:type => 'ALL'})
      files.should be_kind_of(ConstantContact::Components::ResultSet)
      files.results.first.should be_kind_of(ConstantContact::Components::LibraryFile)
      files.results.first.name.should eq('IMG_0341.JPG')
    end
  end

  describe "#get_library_files_by_folder" do
    it "retrieves a collection of MyLibrary files in the Constant Contact account" do
      folder_id = -1
      json_response = load_file('library_files_by_folder_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      files = ConstantContact::Services::LibraryService.get_library_files_by_folder(folder_id, {:limit => 10})
      files.should be_kind_of(ConstantContact::Components::ResultSet)
      files.results.first.should be_kind_of(ConstantContact::Components::LibraryFile)
      files.results.first.name.should eq('IMG_0341.JPG')
    end
  end

  describe "#get_library_file" do
    it "retrieve a MyLibrary file using the file_id path parameter" do
      json = load_file('library_file_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      file = ConstantContact::Services::LibraryService.get_library_file(6)
      file.should be_kind_of(ConstantContact::Components::LibraryFile)
      file.name.should eq('IMG_0261.JPG')
    end
  end

  describe "#add_library_file" do
    it "adds a new MyLibrary file using the multipart content-type" do
      file_name = 'logo.jpg'
      folder_id = 1
      description = 'Logo'
      source = 'MyComputer'
      file_type = 'JPG'
      contents = load_file('logo.jpg')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')
      net_http_resp.add_field('Location', 'https://api.d1.constantcontact.com/v2/library/files/123456789')

      response = RestClient::Response.create("", net_http_resp, {})
      RestClient.stub(:post).and_return(response)

      response = ConstantContact::Services::LibraryService.add_library_file(file_name, folder_id, description, source, file_type, contents)
      response.should be_kind_of(String)
      response.should eq('123456789')
    end
  end

  describe "#update_library_file" do
    it "updates information for a specific MyLibrary file" do
      json = load_file('library_file_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:put).and_return(response)
      file = ConstantContact::Components::LibraryFile.create(JSON.parse(json))

      response = ConstantContact::Services::LibraryService.update_library_file(file)
      response.should be_kind_of(ConstantContact::Components::LibraryFile)
      response.name.should eq('IMG_0261.JPG')
    end
  end

  describe "#delete_library_file" do
    it "deletes one or more MyLibrary files specified by the fileId path parameter" do
      file_id = '6, 7'
      net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

      response = RestClient::Response.create('', net_http_resp, {})
      RestClient.stub(:delete).and_return(response)

      result = ConstantContact::Services::LibraryService.delete_library_file(file_id)
      result.should be_true
    end
  end

  describe "#get_library_files_upload_status" do
    it "retrieves the upload status for one or more MyLibrary files using the file_id path parameter" do
      file_id = '6, 7'
      json = load_file('library_files_upload_status_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      statuses = ConstantContact::Services::LibraryService.get_library_files_upload_status(file_id)
      statuses.should be_kind_of(Array)
      statuses.first.should be_kind_of(ConstantContact::Components::UploadStatus)
      statuses.first.status.should eq('Active')
    end
  end

  describe "#move_library_files" do
    it "moves one or more MyLibrary files to a different folder in the user's account" do
      folder_id = 1
      file_id = '8, 9'
      json = load_file('library_files_move_results_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:put).and_return(response)

      results = ConstantContact::Services::LibraryService.move_library_files(folder_id, file_id)
      results.should be_kind_of(Array)
      results.first.should be_kind_of(ConstantContact::Components::MoveResults)
      results.first.uri.should eq('https://api.d1.constantcontact.com/v2/library/files/9')
    end
  end
end