require 'spec_helper'

describe CustomFields::Types::RemoteSource do

  before(:each) do
    @blog = create_blog
  end

  describe 'a new post' do

    before(:each) do
      @post = @blog.posts.build :title => 'Hello world', :body => 'Lorem ipsum...'
    end

    it 'sets the remote source' do
      @post.source = 'http://some.api.com'
      @post.attributes['source'].should == 'http://some.api.com'
    end

    it 'returns the remote source' do
      @post.source = 'http://some.api.com'
      @post.source.should == 'http://some.api.com'
    end
    
    it 'validates a source as a URI' do
      @source_field.required = true
      @source_field.save!
      @post.source = 'not a uri'
      debugger
      @post.save!.should be_false
    end
    

  end

  describe 'an existing post' do

    before(:each) do
      @post = @blog.posts.create :title => 'Hello world', :body => 'Lorem ipsum...', :author => 'John Doe', :source => 'http://some.api.com'

      Object.send(:remove_const, @post.custom_fields_recipe['name'])

      @post = Post.find(@post._id)
    end

    it 'returns the source' do
      @post.source.should == 'http://some.api.com'
    end

    it 'also returns the source' do
      blog = Blog.find(@blog._id)
      post = blog.posts.find(@post._id)
      post.source.should == 'http://some.api.com'
    end

    it 'sets a new source' do
      @post.source = 'http://some.other.api.com'
      @post.save
      @post = Post.find(@post._id)
      @post.source.should == 'http://some.other.api.com'
    end

  end

  def create_blog
    Blog.new(:name => 'My personal blog').tap do |blog|
      blog.posts_custom_fields.build :label => 'author', :type => 'string'
      @source_field = blog.posts_custom_fields.build :label => 'source', :type => 'remote_source'
      blog.save & blog.reload
    end
  end
end