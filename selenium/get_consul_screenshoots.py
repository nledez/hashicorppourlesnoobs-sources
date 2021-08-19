import os
import time

from selenium import webdriver
from selenium.webdriver.common.keys import Keys

CONSUL_ROOT_URL = 'http://127.0.0.1:8500'
CONSUL_DC = 'dc1'

driver = webdriver.Firefox()
#driver.maximize_window()

def wait_by_css_selector(driver, css_selector):
    again = True
    while again:
        time.sleep(1)
        all_elements = driver.find_elements_by_css_selector(css_selector)
        if len(all_elements) > 0:
            return all_elements

def click_by_link_text(driver, link_text):
    driver.find_element_by_link_text(link_text).click()

def click_by_button_text(driver, button_text):
    driver.find_element_by_xpath("//button[contains(., '{}')]".format(button_text)).click()

os.system('consul kv delete dossier/')

driver.get('{}/ui/{}/services'.format(CONSUL_ROOT_URL, CONSUL_DC))
wait_by_css_selector(driver, 'h1')
driver.save_screenshot('consul/consul-01-services.png')

click_by_button_text(driver, 'Help')
driver.save_screenshot('consul/consul-01-version.png')

click_by_link_text(driver, 'Nodes')
wait_by_css_selector(driver, 'h1')
driver.save_screenshot('consul/consul-02-nodes.png')

click_by_link_text(driver, 'Key/Value')
wait_by_css_selector(driver, 'h1')
driver.save_screenshot('consul/consul-03-kv-empty.png')

os.system('consul kv put dossier/')
os.system('consul kv put dossier/value 42')
os.system('consul kv get dossier/value')

click_by_link_text(driver, 'Nodes')
click_by_link_text(driver, 'Key/Value')
click_by_link_text(driver, 'dossier')
click_by_link_text(driver, 'value')
wait_by_css_selector(driver, 'h1')
driver.save_screenshot('consul/consul-04-with-value.png')

driver.close()
