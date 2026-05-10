use serde_json::Value;
pub fn merge_json(json1: &str, json2: &str) -> Value {
    let mut parsed1: Value = serde_json::from_str(json1).expect("Failed to parse first JSON");
    let parsed2: Value = serde_json::from_str(json2).expect("Failed to parse second JSON");

    if let (Value::Object(obj1), Value::Object(obj2)) = (&mut parsed1, &parsed2) {
        obj1.extend(obj2.clone()); // Merge obj2 into obj1
    }

    parsed1
}
