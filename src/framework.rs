#[derive(Debug, Serialize, Deserialize, Clone, PartialEq)]
pub enum Framework {
    #[serde(alias = "default")]
    #[serde(rename = "vanilla")]
    Vanilla,
    #[serde(rename = "react")]
    React,
    #[serde(rename = "fusion-0.4")]
    Fusion4,
    #[serde(alias = "fusion")]
    #[serde(rename = "fusion-0.3")]
    Fusion3,
    #[serde(rename = "fusion-0.2")]
    Fusion2,
    #[serde(rename = "fusion-0.1")]
    Fusion1,
}
