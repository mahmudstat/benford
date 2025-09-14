from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait, Select
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By

# Use full real path to Brave (not just /usr/bin/brave-browser)
brave_path = "/opt/brave.com/brave/brave"  # <-- update this if different
chromedriver_path = "vote/chromedriver-linux64/chromedriver"

options = Options()
options.binary_location = brave_path

service = Service(executable_path=chromedriver_path)
driver = webdriver.Chrome(service=service, options=options)

driver.get("http://103.183.38.72/resultdetail/index.php")




# Let it load
time.sleep(2)


dropdown = Select(WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.ID, "constituencyid"))
))

for index, option in enumerate(dropdown.options[1:], start=1):
    name = option.text.strip().replace(" ", "_").replace("–", "-")
    print(f"Processing: {name}")

    # Select constituency
    dropdown.select_by_index(index)
    time.sleep(1)  # Let dropdown finish AJAX update

    # Click the "দেখাও" button
    try:
        show_button = WebDriverWait(driver, 10).until(
    EC.element_to_be_clickable((By.NAME, "showresult"))
)
show_button.click()


        # Wait for table to appear
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CLASS_NAME, "table-responsive"))
        )

        # Read table with pandas
        html = driver.page_source
        tables = pd.read_html(html)

        if tables:
            df = tables[0]
            df.to_csv(f"data/{name}.csv", index=False)
            print(f"Saved: {name}.csv")
        else:
            print(f"No table found for {name}")

    except Exception as e:
        print(f"Error in {name}: {e}")

    time.sleep(2)  # polite delay

driver.quit()

