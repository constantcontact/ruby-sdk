#
# library_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Services
    class LibraryService < BaseService
      class << self

        # Retrieve MyLibrary usage information
        # @return [LibrarySummary]
        def get_library_info()
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.library_info')

          response = RestClient.get(url, get_headers())
          Components::LibrarySummary.create(JSON.parse(response.body).first)
        end


        # Retrieve a list of MyLibrary folders
        # @param [Hash] params - hash of query parameters and values to append to the request.
        #     Allowed parameters include:
        #     sort_by - The method to sort by, valid values are :
        #         CREATED_DATE - sorts by date folder was added, ascending (earliest to latest)
        #         CREATED_DATE_DESC - (default) sorts by date folder was added, descending (latest to earliest)
        #         MODIFIED_DATE - sorts by date folder was last modified, ascending (earliest to latest)
        #         MODIFIED_DATE_DESC - sorts by date folder was last modified, descending (latest to earliest)
        #         NAME - sorts alphabetically by folder name, a to z
        #         NAME_DESC - sorts alphabetically by folder name, z to a
        #     limit -  Specifies the number of results displayed per page of output, from 1 - 50, default = 50.
        # @return [ResultSet<LibraryFolder>]
        def get_library_folders(params)
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.library_folders')
          url = build_url(url, params)
          response = RestClient.get(url, get_headers())
          folders = []
          body = JSON.parse(response.body)
          body['results'].each do |folder|
            folders << Components::LibraryFolder.create(folder)
          end
          Components::ResultSet.new(folders, body['meta'])
        end


        # Create a new MyLibrary folder
        # @param [LibraryFolder] folder - MyLibrary folder to be created
        # @return [LibraryFolder]
        def add_library_folder(folder)
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.library_folders')
          url = build_url(url)
          payload = folder.to_json
          response = RestClient.post(url, payload, get_headers())
          Components::LibraryFolder.create(JSON.parse(response.body))
        end


        # Retrieve a specific MyLibrary folder using the folder_id path parameter
        # @param [String] folder_id - The ID for the folder to return
        # @return [LibraryFolder]
        def get_library_folder(folder_id)
          url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.library_folder'), folder_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers())
          Components::LibraryFolder.create(JSON.parse(response.body))
        end


        # Update a specific MyLibrary folder
        # @param [LibraryFolder] folder - MyLibrary folder to be updated
        # @return [LibraryFolder]
        def update_library_folder(folder)
          url = Util::Config.get('endpoints.base_url') + 
                sprintf(Util::Config.get('endpoints.library_folder'), folder.id)
          url = build_url(url)
          payload = folder.to_json
          response = RestClient.put(url, payload, get_headers())
          Components::LibraryFolder.create(JSON.parse(response.body))
        end


        # Delete a MyLibrary folder
        # @param [String] folder_id - The ID for the MyLibrary folder to delete
        # @return [Boolean]
        def delete_library_folder(folder_id)
          url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.library_folder'), folder_id)
          url = build_url(url)
          response = RestClient.delete(url, get_headers())
          response.code == 204
        end


        # Retrieve all files in the Trash folder
        # @param [Hash] params - hash of query parameters and values to append to the request.
        #     Allowed parameters include:
        #     type - Specifies the type of files to retrieve, valid values are : ALL, IMAGES, or DOCUMENTS
        #     sort_by - The method to sort by, valid values are :
        #         ADDED_DATE - sorts by date folder was added, ascending (earliest to latest)
        #         ADDED_DATE_DESC - (default) sorts by date folder was added, descending (latest to earliest)
        #         MODIFIED_DATE - sorts by date folder was last modified, ascending (earliest to latest)
        #         MODIFIED_DATE_DESC - sorts by date folder was last modified, descending (latest to earliest)
        #         NAME - sorts alphabetically by file name, a to z
        #         NAME_DESC - sorts alphabetically by file name, z to a
        #         SIZE - sorts by file size, smallest to largest
        #         SIZE_DESC - sorts by file size, largest to smallest
        #         DIMENSION - sorts by file dimensions (hxw), smallest to largest
        #         DIMENSION_DESC - sorts by file dimensions (hxw), largest to smallest
        #     limit -  Specifies the number of results displayed per page of output, from 1 - 50, default = 50.
        # @return [ResultSet<LibraryFile>]
        def get_library_trash(params)
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.library_folder_trash')
          url = build_url(url, params)
          response = RestClient.get(url, get_headers())
          files = []
          body = JSON.parse(response.body)
          body['results'].each do |file|
            files << Components::LibraryFile.create(file)
          end
          Components::ResultSet.new(files, body['meta'])
        end


        # Permanently deletes all files in the Trash folder
        # @return [Boolean]
        def delete_library_trash()
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.library_folder_trash')
          url = build_url(url)
          response = RestClient.delete(url, get_headers())
          response.code == 204
        end


        # Retrieve a collection of MyLibrary files in the Constant Contact account
        # @param [Hash] params - hash of query parameters and values to append to the request.
        #     Allowed parameters include:
        #     type - Specifies the type of files to retrieve, valid values are : ALL, IMAGES, or DOCUMENTS
        #     source - Specifies to retrieve files from a particular source, valid values are :
        #         ALL - (default) files from all sources
        #         MyComputer
        #         StockImage
        #         Facebook
        #         Instagram
        #         Shutterstock
        #         Mobile
        #     limit -  Specifies the number of results displayed per page of output, from 1 - 1000, default = 50.
        # @return [ResultSet<LibraryFile>]
        def get_library_files(params = {})
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.library_files')
          url = build_url(url, params)
          response = RestClient.get(url, get_headers())
          files = []
          body = JSON.parse(response.body)
          body['results'].each do |file|
            files << Components::LibraryFile.create(file)
          end
          Components::ResultSet.new(files, body['meta'])
        end


        # Retrieves all files from a MyLibrary folder specified by the folder_id path parameter
        # @param [String] folder_id  - Specifies the folder from which to retrieve files
        # @param [Hash] params - hash of query parameters and values to append to the request.
        #     Allowed parameters include:
        #     limit - Specifies the number of results displayed per page of output, from 1 - 50, default = 50.
        # @return [ResultSet<LibraryFile>]
        def get_library_files_by_folder(folder_id, params = {})
          url = Util::Config.get('endpoints.base_url') + 
                sprintf(Util::Config.get('endpoints.library_files_by_folder'), folder_id)
          url = build_url(url, params)
          response = RestClient.get(url, get_headers())
          files = []
          body = JSON.parse(response.body)
          body['results'].each do |file|
            files << Components::LibraryFile.create(file)
          end
          Components::ResultSet.new(files, body['meta'])
        end


        # Retrieve a MyLibrary file using the file_id path parameter
        # @param [String] file_id - Specifies the MyLibrary file for which to retrieve information
        # @return [LibraryFile]
        def get_library_file(file_id)
          url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.library_file'), file_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers())
          Components::LibraryFile.create(JSON.parse(response.body))
        end


        # Adds a new MyLibrary file using the multipart content-type
        # @param [String] file_name - The name of the file (ie: dinnerplate-special.jpg)
        # @param [String] folder_id - Folder id to add the file to
        # @param [String] description - The description of the file provided by user 
        # @param [String] source - indicates the source of the original file; 
        #                          image files can be uploaded from the following sources :
        #                          MyComputer, StockImage, Facebook - MyLibrary Plus customers only,
        #                          Instagram - MyLibrary Plus customers only, Shutterstock, Mobile
        # @param [String] file_type - Specifies the file type, valid values are: JPEG, JPG, GIF, PDF, PNG 
        # @param [String] contents - The content of the file
        # @return [LibraryFile]
        def add_library_file(file_name, folder_id, description, source, file_type, contents)
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.library_files')
          url = build_url(url)

          payload = { :file_name => file_name, :folder_id => folder_id, 
                      :description => description, :source => source, :file_type => file_type, 
                      :data => contents, :multipart => true }

          response = RestClient.post(url, payload, get_headers())
          location = response.headers[:location] || ''
          location.split('/').last
        end


        # Update information for a specific MyLibrary file
        # @param [LibraryFile] file - Library File to be updated
        # @return [LibraryFile]
        def update_library_file(file)
          url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.library_file'), file.id)
          url = build_url(url)
          payload = file.to_json
          response = RestClient.put(url, payload, get_headers())
          Components::LibraryFile.create(JSON.parse(response.body))
        end


        # Delete one or more MyLibrary files specified by the fileId path parameter; 
        # separate multiple file IDs with a comma. 
        # Deleted files are moved from their current folder into the system Trash folder, and its status is set to Deleted.
        # @param [String] file_id - Specifies the MyLibrary file to delete
        # @return [Boolean]
        def delete_library_file(file_id)
          url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.library_file'), file_id)
          url = build_url(url)
          response = RestClient.delete(url, get_headers())
          response.code == 204
        end


        # Retrieve the upload status for one or more MyLibrary files using the file_id path parameter; 
        # separate multiple file IDs with a comma
        # @param [String] file_id - Specifies the files for which to retrieve upload status information
        # @return [Array<UploadStatus>]
        def get_library_files_upload_status(file_id)
          url = Util::Config.get('endpoints.base_url') + 
                sprintf(Util::Config.get('endpoints.library_file_upload_status'), file_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers())
          statuses = []
          JSON.parse(response.body).each do |status|
            statuses << Components::UploadStatus.create(status)
          end
          statuses
        end


        # Move one or more MyLibrary files to a different folder in the user's account
        # specify the destination folder using the folder_id path parameter. 
        # @param [String] folder_id - Specifies the destination MyLibrary folder to which the files will be moved
        # @param [String] file_id - Specifies the files to move, in a string of comma separated file ids (e.g. 8,9)
        # @return [Array<MoveResults>]
        def move_library_files(folder_id, file_id)
          url = Util::Config.get('endpoints.base_url') + 
                sprintf(Util::Config.get('endpoints.library_file_move'), folder_id)
          url = build_url(url)
 
          payload = file_id.split(',').map {|id| id.strip}.to_json
          response = RestClient.put(url, payload, get_headers())
          results = []
          JSON.parse(response.body).each do |result|
            results << Components::MoveResults.create(result)
          end
          results
        end

      end
    end
  end
end