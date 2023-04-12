# frozen_string_literal: true

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test 'product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test 'product price must be positive' do
    p = Product.new(title: 'My Book Title', description: 'yyy',
                    image_url: 'zzz.jpg')
    p.price = -1
    assert p.invalid?
    assert_equal ['must be greater than or equal to 0.01'], p.errors[:price]

    p.price = 0
    assert p.invalid?
    assert_equal ['must be greater than or equal to 0.01'], p.errors[:price]

    p.price = 1
    assert p.valid?
  end

  test 'image url' do
    ok = %w[ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c/x/y/z/fred.gif ]
    bad = %w[fred.doc fred.gif/more fred.gif.more]
    ok.each do |image_url|
      assert new_product(image_url).valid?, "#{image_url} should be valid"
    end
    bad.each do |image_url|
      assert new_product(image_url).invalid?, "#{image_url} should not be valid"
    end
  end

  test 'product is not valud without a unique title' do
    p = Product.new(title: products(:ruby).title, description: 'yyy', price: 1,
                    image_url: 'fred.gif')
    assert p.invalid?
    assert_equal ['has already been taken'], p.errors[:title]
  end

  test 'product is not valud without a unique title - i18n' do
    p = Product.new(title: products(:ruby).title, description: 'yyy', price: 1,
                    image_url: 'fred.gif')
    assert p.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], p.errors[:title]
  end

  def new_product(image_url)
    p = Product.new(title: 'My Book Title', description: 'yyy', price: 1,
                    image_url:)
  end
end
