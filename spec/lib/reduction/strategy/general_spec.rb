# encoding: UTF-8

require 'spec_helper'
require 'open-uri'

module Reduction
  class Strategy

    describe General do
      use_vcr_cassette 'general'

      let(:url) { 'http://allthingssimpleblog.com/2011/11/22/earl-grey-latte-poor-mans-milk-foam/'}
      let(:html) { open(url).read }
      let(:doc) { subject.doc }

      subject { described_class.new(html, url) }

      it_should_behave_like "a strategy"

      it_should_find 'title', 'Earl Grey Latte + Poor Man’s Milk Foam « All Things Simple'

      let(:image_srcs) do
        [
          # These values came from the HTML doc/VCR cassette
          "http://lbrisbo.files.wordpress.com/2011/11/earl-grey5.jpg?w=490&h=367",
          "http://lbrisbo.files.wordpress.com/2011/11/earlgrey3.jpg?w=490&h=326",
          "http://lbrisbo.files.wordpress.com/2011/11/earlgrey2.jpg?w=490&h=326",
          "http://lbrisbo.files.wordpress.com/2011/11/earlgrey1.jpg?w=490&h=326",
          "http://lbrisbo.files.wordpress.com/2011/11/earl-grey8.jpg?w=490&h=367",
          "http://lbrisbo.files.wordpress.com/2011/11/earl-grey10.jpg?w=490&h=367",
          "http://0.gravatar.com/avatar/06455523222946a07e7cd5a76532c0a6?s=30&d=identicon&r=G",
          "http://0.gravatar.com/avatar/6e680aa6d539cd762b87583cb921781c?s=30&d=identicon&r=G",
          "http://1.gravatar.com/avatar/35a3837110051f80baa1eea5993ae576?s=30&d=identicon&r=G"
        ]
      end

      describe '#body' do

        it 'returns a string' do
          subject.body.should be_a(String)
        end

        it 'distills the document' do
          Distillery.should_receive(:distill).with(doc.to_s, images: true).
            and_return(doc.to_s)
          subject.body
        end

        it 'loofahs the distilled document with the custom scrubber' do
          Distillery.should_receive(:distill).with(doc.to_s, images: true).
            and_return(doc.to_s)
          Loofah.should_receive(:scrub_fragment).
            with(doc.to_s, an_instance_of(described_class::Scrubber)).
            and_return(doc)
          
          subject.body
        end

        it 'keeps out body, html, head and doctype tags' do
          subject.body.should_not =~ %r|<body|
          subject.body.should_not =~ %r|<html|
          subject.body.should_not =~ %r|<head|
          subject.body.should_not =~ %r|<!DOCTYPE|
        end

        it 'should preserve image sources' do
          escaped_image_paths = image_srcs.map { |s| s.gsub('&', '&amp;') }
          subject.body.should include(*escaped_image_paths)
        end

        it 'should preserve anchor hrefs' do
          subject.body.should include('http://www.thekitchn.com/thekitchn/tips-techniques/how-to-make-milk-foam-without-a-machine-100716')
        end

        context 'when the HTML has custom <nyt_*> elements' do
          let(:url) { 'http://www.nytimes.com/2008/10/07/health/nutrition/07recipehealth.html' }

          it 'preserves those elements' do
            subject.body.should include('You may be familiar with Spanakopita')
            subject.body.should include('4 ounces feta cheese')
            subject.body.should include('for 10 to 20 minutes.')
          end
        end

        context 'when the page contains relative urls and images' do
          let(:html) { <<-CODE }
            <a href="a/b../c">bar</a>
            <a href="http://allthingssimpleblog.com/about">existing</a>
            <img src="d/e/f../g/h">
            <img src="http://allthingssimpleblog.com/hello.jpg">
          CODE

          it 'resolves the img srcs to make them absolute' do
            subject.body.should include('http://allthingssimpleblog.com/2011/11/22/earl-grey-latte-poor-mans-milk-foam/d/e/f../g/h')
            subject.body.should include('http://allthingssimpleblog.com/hello.jpg')
          end

          it 'resolves anchor hfres to make them absolute' do
            subject.body.should include('http://allthingssimpleblog.com/2011/11/22/earl-grey-latte-poor-mans-milk-foam/a/b../c')
            subject.body.should include('http://allthingssimpleblog.com/about')
          end

        end

      end

      describe '#images' do
        it 'returns all images in the distilled doc' do
          subject.images.should == image_srcs
        end
      end

    end

  end
end