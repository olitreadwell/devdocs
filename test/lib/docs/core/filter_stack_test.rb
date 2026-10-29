require_relative '../../../test_helper'
require_relative '../../../../lib/docs'

class DocsFilterStackTest < Minitest::Spec
  let :stack do
    Docs::FilterStack.new
  end

  def push(*names)
    stack.push(*names)
    stack.to_a
  end

  describe "#push" do
    it "resolves a filter name to its Docs constant" do
      assert_equal [Docs::ContainerFilter], push('container')
    end

    it "resolves and appends every given name, in order" do
      assert_equal [Docs::ContainerFilter, Docs::CleanHtmlFilter, Docs::NormalizeUrlsFilter],
        push('container', 'clean_html', 'normalize_urls')
    end

    it "resolves namespaced filter names" do
      assert_equal [Docs::Mdn::CleanHtmlFilter, Docs::Mdn::CompatTablesFilter],
        push('mdn/clean_html', 'mdn/compat_tables')
    end

    it "appends duplicate filters" do
      assert_equal [Docs::ImagesFilter, Docs::ImagesFilter], push('images', 'images')
    end
  end

  describe "#initialize" do
    it "starts empty" do
      assert_empty Docs::FilterStack.new.to_a
    end

    it "duplicates the array it is given" do
      source = [Docs::ContainerFilter]
      stack = Docs::FilterStack.new(source)
      source.push Docs::CleanHtmlFilter
      assert_equal [Docs::ContainerFilter], stack.to_a
    end
  end

  describe "#length" do
    it "returns the number of filters" do
      stack.push 'container', 'clean_html'
      assert_equal 2, stack.length
    end
  end

  describe "#insert" do
    it "inserts before the filter at an integer index" do
      stack.push 'container', 'normalize_urls'
      stack.insert 1, 'clean_html'
      assert_equal [Docs::ContainerFilter, Docs::CleanHtmlFilter, Docs::NormalizeUrlsFilter], stack.to_a
    end

    it "inserts before the filter named by the index" do
      stack.push 'container', 'normalize_urls'
      stack.insert 'normalize_urls', 'clean_html'
      assert_equal [Docs::ContainerFilter, Docs::CleanHtmlFilter, Docs::NormalizeUrlsFilter], stack.to_a
    end

    it "accepts several filters at once" do
      stack.push 'container', 'normalize_urls'
      stack.insert 1, 'clean_html', 'images'
      assert_equal [Docs::ContainerFilter, Docs::CleanHtmlFilter, Docs::ImagesFilter, Docs::NormalizeUrlsFilter], stack.to_a
    end

    it "is aliased as #insert_before" do
      stack.push 'container', 'normalize_urls'
      stack.insert_before 'normalize_urls', 'clean_html'
      assert_equal [Docs::ContainerFilter, Docs::CleanHtmlFilter, Docs::NormalizeUrlsFilter], stack.to_a
    end

    it "raises when the index names a filter that isn't in the stack" do
      stack.push 'container'
      error = assert_raises(RuntimeError) { stack.insert_before 'clean_html', 'normalize_urls' }
      assert_equal 'No such filter to insert: clean_html', error.message
    end
  end

  describe "#insert_after" do
    it "inserts after the filter named by the index" do
      stack.push 'container', 'clean_html'
      stack.insert_after 'container', 'normalize_urls'
      assert_equal [Docs::ContainerFilter, Docs::NormalizeUrlsFilter, Docs::CleanHtmlFilter], stack.to_a
    end

    it "raises when the index names a filter that isn't in the stack" do
      stack.push 'container'
      error = assert_raises(RuntimeError) { stack.insert_after 'clean_html', 'normalize_urls' }
      assert_equal 'No such filter to insert: clean_html', error.message
    end
  end

  describe "#replace" do
    it "replaces the filter at an integer index" do
      stack.push 'container', 'clean_html'
      assert_same Docs::NormalizeUrlsFilter, stack.replace(1, 'normalize_urls')
      assert_equal [Docs::ContainerFilter, Docs::NormalizeUrlsFilter], stack.to_a
    end

    it "replaces the filter named by the index" do
      stack.push 'container', 'clean_html'
      stack.replace 'clean_html', 'normalize_urls'
      assert_equal [Docs::ContainerFilter, Docs::NormalizeUrlsFilter], stack.to_a
    end
  end

  describe "#==" do
    it "returns true for stacks holding the same filters" do
      stack.push 'container', 'clean_html'
      other = Docs::FilterStack.new
      other.push 'container', 'clean_html'
      assert_equal stack, other
    end

    it "returns false when the filters differ" do
      stack.push 'container'
      refute_equal stack, Docs::FilterStack.new
    end
  end

  describe "#to_a" do
    it "returns a copy that doesn't expose the internal array" do
      stack.push 'container'
      stack.to_a.push Docs::CleanHtmlFilter
      assert_equal [Docs::ContainerFilter], stack.to_a
    end
  end

  describe "#inheritable_copy" do
    it "returns a new stack holding the same filters" do
      stack.push 'container', 'clean_html'
      assert_equal stack, stack.inheritable_copy
      refute_same stack, stack.inheritable_copy
    end

    it "lets the copy be changed without affecting the original" do
      stack.push 'container'
      copy = stack.inheritable_copy
      copy.push 'clean_html'
      assert_equal [Docs::ContainerFilter], stack.to_a
      assert_equal [Docs::ContainerFilter, Docs::CleanHtmlFilter], copy.to_a
    end
  end
end
