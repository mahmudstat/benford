from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait, Select
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.core.os_manager import ChromeType
import pandas as pd
import time
import os

# Brave browser path
brave_path = "/opt/brave.com/brave/brave"

def main():
    driver = None
    try:
        print("Setting up Brave browser with compatible driver...")
        
        # Setup options
        options = Options()
        options.binary_location = brave_path
        options.add_argument("--no-sandbox")
        options.add_argument("--disable-dev-shm-usage")
        
        # Use webdriver-manager with Brave specific driver
        service = Service(ChromeDriverManager(chrome_type=ChromeType.BRAVE).install())
        driver = webdriver.Chrome(service=service, options=options)
        
        print("✓ Browser initialized successfully")
        
        print("Navigating to election website...")
        driver.get("http://103.183.38.72/resultdetail/index.php")
        time.sleep(3)
        
        # Create data directory
        if not os.path.exists('election_data'):
            os.makedirs('election_data')
            print("✓ Created election_data directory")
        
        print("Finding constituency dropdown...")
        dropdown = Select(WebDriverWait(driver, 15).until(
            EC.presence_of_element_located((By.ID, "constituencyid"))
        ))

        print("✓ Found constituency dropdown")
        
        all_data = []
        constituencies = []

        # Collect all constituency names (skip first option if it's ---SELECT---)
        for index, option in enumerate(dropdown.options):
            name = option.text.strip()
            if name and name not in ["", "---SELECT---", "Select"]:
                constituencies.append((index, name))
                print(f"  Found: {name}")
        
        print(f"📊 Total constituencies to process: {len(constituencies)}")
        
        # Process each constituency
        for i, (index, name) in enumerate(constituencies, 1):
            clean_name = name.replace(" ", "_").replace("–", "-").replace("/", "-")
            print(f"\n[{i}/{len(constituencies)}] Processing: {name}")

            try:
                # Select constituency
                dropdown.select_by_index(index)
                time.sleep(2)

                # Click the show button
                show_button = WebDriverWait(driver, 10).until(
                    EC.element_to_be_clickable((By.NAME, "showresult"))
                )
                show_button.click()
                time.sleep(3)

                # Extract table data
                html = driver.page_source
                tables = pd.read_html(html)

                if tables:
                    df = tables[0]
                    if not df.empty:
                        # Clean the dataframe
                        df = df.dropna(how='all').dropna(axis=1, how='all')
                        df['Constituency'] = name
                        
                        # Save individual file
                        filename = f"election_data/{clean_name}.csv"
                        df.to_csv(filename, index=False, encoding='utf-8-sig')
                        all_data.append(df)
                        print(f"  ✅ Saved: {filename} ({len(df)} rows)")
                    else:
                        print(f"  ⚠ Empty table for {name}")
                else:
                    print(f"  ❌ No tables found for {name}")

            except Exception as e:
                print(f"  ❌ Error processing {name}: {str(e)}")
                # Continue with next constituency

            # Polite delay between requests
            time.sleep(2)

        # Save combined data
        if all_data:
            combined_df = pd.concat(all_data, ignore_index=True)
            combined_filename = "election_data/ALL_CONSTITUENCIES.csv"
            combined_df.to_csv(combined_filename, index=False, encoding='utf-8-sig')
            print(f"\n🎉 SUCCESS!")
            print(f"✅ Combined data saved: {combined_filename}")
            print(f"📊 Total constituencies processed: {len(all_data)}")
            print(f"📈 Total records: {len(combined_df)}")
        else:
            print("\n❌ No data was successfully extracted")

    except Exception as e:
        print(f"💥 Error: {e}")
        import traceback
        traceback.print_exc()
        
    finally:
        if driver:
            driver.quit()
            print("🔒 Browser closed")

if __name__ == "__main__":
    main()