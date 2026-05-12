import hashlib, os, sys, time, jwt, requests

KEY_ID = "WDXGY9WX55"
ISSUER = "2be0734f-943a-4d61-9dc9-5d9045c46fec"
BUNDLE_ID = "com.tokyonasu.aiexcusemaker"
APP_VERSION = "1.0"
BUILD_NUMBER = sys.argv[1]
SCREENSHOT_DIR = "MarketingAssets/Screenshots"

SCREENSHOT_GROUPS = [
    ("APP_IPHONE_67", ["iphone69_01_home.png","iphone69_02_category.png","iphone69_03_result.png","iphone69_04_history.png"]),
    ("APP_IPHONE_65", ["iphone65_01_home.png","iphone65_02_category.png","iphone65_03_result.png","iphone65_04_history.png"]),
    ("APP_IPHONE_55", ["iphone55_01_home.png","iphone55_02_category.png","iphone55_03_result.png","iphone55_04_history.png"]),
    ("APP_IPAD_PRO_3GEN_129", ["ipad129_01_home.png","ipad129_02_category.png","ipad129_03_result.png","ipad129_04_history.png"]),
]

WHATS_NEW = {"ja": "はじめてのリリースです。", "en-US": "Initial release."}
DESCRIPTION = {
    "ja": "遅刻、約束忘れ、宿題、ドタキャン…\nギリギリ許されそうな言い訳を秒速生成。\n\n8カテゴリ × 3トーン × 3強さで72通り。\nコピーしてそのまま送れます。",
    "en-US": "Late again? Forgot a promise?\nAI Excuse Maker generates believable excuses instantly.\n\n8 categories x 3 tones x 3 levels = 72 combinations.",
}
KEYWORDS = {
    "ja": "言い訳,AI,ジョーク,遅刻,謝罪,面白い,爆笑,ネタ,トーク,サボり",
    "en-US": "excuse,maker,AI,joke,late,funny,generator,humor,comedy,prank",
}

p8 = open("/tmp/asc_key.p8").read()

def make_token():
    now = int(time.time())
    return jwt.encode({"iss": ISSUER, "iat": now, "exp": now + 1200, "aud": "appstoreconnect-v1"}, p8, algorithm="ES256", headers={"kid": KEY_ID})

def headers():
    return {"Authorization": f"Bearer {make_token()}", "Content-Type": "application/json"}

def api(method, path, **kwargs):
    for _ in range(6):
        r = requests.request(method, f"https://api.appstoreconnect.apple.com/v1{path}", headers=headers(), timeout=90, **kwargs)
        if r.status_code not in (401, 500, 502, 503, 504):
            return r
        time.sleep(15)
    return r

def api_json(method, path, **kwargs):
    r = api(method, path, **kwargs)
    try: body = r.json()
    except: body = {}
    return r, body

def list_all(path):
    data, next_path = [], path
    while next_path:
        r, body = api_json("GET", next_path)
        if r.status_code != 200: print(f"List failed: {r.status_code}"); sys.exit(1)
        data.extend(body.get("data", []))
        next_url = body.get("links", {}).get("next")
        next_path = next_url.split("/v1", 1)[1] if next_url else None
    return data

def find_app_id():
    r, body = api_json("GET", f"/apps?filter[bundleId]={BUNDLE_ID}")
    if not body.get("data"): print(f"App not found: {BUNDLE_ID}"); sys.exit(1)
    app_id = body["data"][0]["id"]
    print(f"App ID: {app_id}")
    return app_id

def find_or_create_version(app_id):
    for v in list_all(f"/apps/{app_id}/appStoreVersions?filter[platform]=IOS&limit=200"):
        attrs = v.get("attributes", {})
        if attrs.get("versionString") == APP_VERSION:
            state = attrs.get("appStoreState")
            print(f"Found version {APP_VERSION}: {v['id']} state={state}")
            return v["id"], state
    print(f"Creating version {APP_VERSION}...")
    r, body = api_json("POST", "/appStoreVersions", json={"data": {"type": "appStoreVersions", "attributes": {"platform": "IOS", "versionString": APP_VERSION}, "relationships": {"app": {"data": {"type": "apps", "id": app_id}}}}})
    if r.status_code not in (200, 201): print(f"Failed: {r.status_code} {r.text[:200]}"); sys.exit(1)
    vid = body["data"]["id"]
    print(f"Created: {vid}")
    return vid, "PREPARE_FOR_SUBMISSION"

def wait_for_build(app_id):
    print(f"Waiting for build {BUILD_NUMBER}...")
    for i in range(80):
        r, body = api_json("GET", f"/builds?filter[app]={app_id}&filter[version]={BUILD_NUMBER}&filter[processingState]=VALID&limit=1")
        if body.get("data"):
            bid = body["data"][0]["id"]
            print(f"Build ready: {bid}")
            return bid
        print(f"  Waiting... ({i+1}/80)")
        time.sleep(30)
    print("Build timeout"); sys.exit(1)

def upload_screenshots(version_id):
    print("Uploading screenshots...")
    for loc in list_all(f"/appStoreVersions/{version_id}/appStoreVersionLocalizations?limit=200"):
        locale = loc["attributes"].get("locale", "unknown")
        print(f"  Locale: {locale}")
        sets = list_all(f"/appStoreVersionLocalizations/{loc['id']}/appScreenshotSets?limit=200")
        existing = {s["attributes"]["screenshotDisplayType"]: s["id"] for s in sets}
        for display_type, filenames in SCREENSHOT_GROUPS:
            if display_type in existing:
                set_id = existing[display_type]
            else:
                r, body = api_json("POST", "/appScreenshotSets", json={"data": {"type": "appScreenshotSets", "attributes": {"screenshotDisplayType": display_type}, "relationships": {"appStoreVersionLocalization": {"data": {"type": "appStoreVersionLocalizations", "id": loc["id"]}}}}})
                if r.status_code not in (200, 201): print(f"Create set failed"); sys.exit(1)
                set_id = body["data"]["id"]
            for ss in list_all(f"/appScreenshotSets/{set_id}/appScreenshots?limit=200"):
                api("DELETE", f"/appScreenshots/{ss['id']}")
            for filename in filenames:
                fp = os.path.join(SCREENSHOT_DIR, filename)
                if not os.path.exists(fp): print(f"Missing: {fp}"); sys.exit(1)
                data = open(fp, "rb").read()
                checksum = hashlib.md5(data).hexdigest()
                r, body = api_json("POST", "/appScreenshots", json={"data": {"type": "appScreenshots", "attributes": {"fileName": filename, "fileSize": len(data)}, "relationships": {"appScreenshotSet": {"data": {"type": "appScreenshotSets", "id": set_id}}}}})
                if r.status_code not in (200, 201): continue
                ss_id = body["data"]["id"]
                for op in body["data"]["attributes"]["uploadOperations"]:
                    op_h = {h["name"]: h["value"] for h in op["requestHeaders"]}
                    requests.put(op["url"], headers=op_h, data=data[op["offset"]:op["offset"]+op["length"]], timeout=90)
                r = api("PATCH", f"/appScreenshots/{ss_id}", json={"data": {"type": "appScreenshots", "id": ss_id, "attributes": {"uploaded": True, "sourceFileChecksum": checksum}}})
                if r.status_code == 200: print(f"      OK: {filename}")

def update_locs(version_id):
    locs = list_all(f"/appStoreVersions/{version_id}/appStoreVersionLocalizations?limit=200")
    lang_set = {l["attributes"].get("locale") for l in locs}
    for locale in ["ja", "en-US"]:
        if locale not in lang_set:
            r, body = api_json("POST", "/appStoreVersionLocalizations", json={"data": {"type": "appStoreVersionLocalizations", "attributes": {"locale": locale}, "relationships": {"appStoreVersion": {"data": {"type": "appStoreVersions", "id": version_id}}}}})
            if r.status_code in (200, 201): locs.append(body["data"])
    for loc in locs:
        locale = loc["attributes"].get("locale", "unknown")
        r = api("PATCH", f"/appStoreVersionLocalizations/{loc['id']}", json={"data": {"type": "appStoreVersionLocalizations", "id": loc["id"], "attributes": {"description": DESCRIPTION.get(locale, DESCRIPTION["en-US"]), "keywords": KEYWORDS.get(locale, KEYWORDS["en-US"]), "whatsNew": WHATS_NEW.get(locale, WHATS_NEW["en-US"]), "marketingUrl": "https://snarfnet.github.io/"}}})
        print(f"  Loc {locale}: {r.status_code}")

def submit_for_review(app_id, version_id):
    r, body = api_json("GET", f"/apps/{app_id}/reviewSubmissions?limit=10")
    for sub in body.get("data", []):
        if sub["attributes"]["state"] not in ("COMPLETE","CANCELING","CANCELED","READY_FOR_REVIEW"):
            api("PATCH", f"/reviewSubmissions/{sub['id']}", json={"data": {"type": "reviewSubmissions", "id": sub["id"], "attributes": {"canceled": True}}})
    time.sleep(10)
    r, body = api_json("POST", "/reviewSubmissions", json={"data": {"type": "reviewSubmissions", "attributes": {"platform": "IOS"}, "relationships": {"app": {"data": {"type": "apps", "id": app_id}}}}})
    if r.status_code != 201: print(f"Submission failed: {r.status_code} {r.text[:200]}"); sys.exit(1)
    sub_id = body["data"]["id"]
    print(f"Submission: {sub_id}")
    for attempt in range(20):
        r = api("POST", "/reviewSubmissionItems", json={"data": {"type": "reviewSubmissionItems", "relationships": {"reviewSubmission": {"data": {"type": "reviewSubmissions", "id": sub_id}}, "appStoreVersion": {"data": {"type": "appStoreVersions", "id": version_id}}}}})
        print(f"Add item {attempt+1}/20: {r.status_code}")
        if r.status_code == 201: break
        time.sleep(30)
    r, body = api_json("PATCH", f"/reviewSubmissions/{sub_id}", json={"data": {"type": "reviewSubmissions", "id": sub_id, "attributes": {"submitted": True}}})
    if r.status_code == 200:
        print(f"Submitted! State: {body['data']['attributes']['state']}")
    else:
        print(f"Submit failed: {r.status_code}"); sys.exit(1)

app_id = find_app_id()
version_id, version_state = find_or_create_version(app_id)
if version_state in ("WAITING_FOR_REVIEW", "IN_REVIEW"):
    print(f"Already in review. Done."); sys.exit(0)

build_id = wait_for_build(app_id)
api("PATCH", f"/builds/{build_id}", json={"data": {"type": "builds", "id": build_id, "attributes": {"usesNonExemptEncryption": False}}})
print("Export compliance: done")
update_locs(version_id)
upload_screenshots(version_id)
print("Waiting 5 min for screenshot processing...")
time.sleep(300)
api("PATCH", f"/appStoreVersions/{version_id}/relationships/build", json={"data": {"type": "builds", "id": build_id}})
print("Build assigned")
submit_for_review(app_id, version_id)
