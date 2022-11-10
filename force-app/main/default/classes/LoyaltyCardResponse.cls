public with sharing class LoyaltyCardResponse {
    public Integer id;
	public String uid;
	public String credit_card_number;
	public String credit_card_expiry_date;
	public String credit_card_type;

	
	public static LoyaltyCardResponse parse(String json) {
		return (LoyaltyCardResponse) System.JSON.deserialize(json, LoyaltyCardResponse.class);
	}
}
