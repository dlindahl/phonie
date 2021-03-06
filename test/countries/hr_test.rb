require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

## Croatia
class HRTest < Phonie::TestCase

  def test_zagreb
    parse_test('+38513668734', '385', '1', '3668734', 'Croatia', false)
  end

  def test_mobile
    parse_test('+385915125486', '385', '91', '5125486', 'Croatia', true)
    parse_test('+38598800916', '385', '98', '800916', 'Croatia', true)
  end

  def test_long_without_special_characters
    parse_test('+385915125486', '385', '91', '5125486')
  end

  def test_long_with_special_characters
    parse_test('+ 385 (91) 512 / 5486 ', '385', '91', '5125486')
  end

  def test_long_with_leading_zeros
    parse_test('00385915125486', '385', '91', '5125486')
  end

  def test_zagreb_long_with_leading_zeros
    parse_test('0038513668734', '385', '1', '3668734')
  end

  def test_short_without_special_characters_with_country
    Phonie.configuration.default_country_code = '385'
    parse_test('044885047', '385', '44', '885047')
  end

  def test_zagreb_short_without_special_characters_with_country
    Phonie.configuration.default_country_code = '385'
    parse_test('013668734', '385', '1', '3668734')
  end

  def test_long_with_zero_in_brackets
    Phonie.configuration.default_country_code = nil
    parse_test('+385 (0)1 366 8111', '385', '1', '3668111')
  end

  def test_has_default_country_code
    Phonie.configuration.default_country_code = '385'

    assert_equal Phonie::Phone.parse('+38547451588').has_default_country_code?, true
    assert_equal Phonie::Phone.parse('+16472228242').has_default_country_code?, false
  end

  def test_has_default_area_code
    Phonie.configuration.default_country_code = '385'
    Phonie.configuration.default_area_code = '47'

    assert_equal Phonie::Phone.parse('047/451-588').has_default_area_code?, true
    assert_equal Phonie::Phone.parse('032/336-1456').has_default_area_code?, false
  end

  def test_validates
    assert_equal Phonie::Phone.valid?('00385915125486'), true
    assert_equal Phonie::Phone.valid?('+385915125486'), true
    assert_equal Phonie::Phone.valid?('+385 (91) 512 5486'), true
    assert_equal Phonie::Phone.valid?('+38547451588'), true

    Phonie.configuration.default_country_code = '385'
    assert_equal Phonie::Phone.valid?('0915125486'), true
    assert_equal Phonie::Phone.valid?('091/512-5486'), true
    assert_equal Phonie::Phone.valid?('091/512-5486'), true
    assert_equal Phonie::Phone.valid?('091 512 54 86'), true
    assert_equal Phonie::Phone.valid?('091-512-54-86'), true
    assert_equal Phonie::Phone.valid?('047/451-588'), true
  end
end
