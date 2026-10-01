package com.heritage.food.dto;

import com.heritage.food.model.MerchantContentSubmission;
import com.heritage.food.model.MerchantProductSubmission;
import com.heritage.food.model.MerchantProfile;
import com.heritage.food.model.MerchantSettlement;
import com.heritage.food.model.MerchantWithdrawal;
import lombok.Data;

import java.util.List;

@Data
public class MerchantWorkspaceResponse {
    private MerchantProfile profile;
    private List<MerchantProductSubmission> products;
    private List<MerchantContentSubmission> contents;
    private List<MerchantSettlement> settlements;
    private List<MerchantWithdrawal> withdrawals;
}
