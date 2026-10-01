package com.heritage.food.dto;

import com.heritage.food.model.MerchantArtisan;
import com.heritage.food.model.MerchantContentSubmission;
import com.heritage.food.model.MerchantOnboardingApplication;
import com.heritage.food.model.MerchantProductSubmission;
import com.heritage.food.model.MerchantQualificationApplication;
import com.heritage.food.model.MerchantSettlement;
import com.heritage.food.model.MerchantWithdrawal;
import lombok.Data;

import java.util.List;

@Data
public class MerchantAdminWorkspaceResponse {
    private List<MerchantAccountDto> accounts;
    private List<MerchantOnboardingApplication> onboardingApplications;
    private List<MerchantQualificationApplication> qualificationApplications;
    private List<MerchantSettlement> settlementRecords;
    private List<MerchantWithdrawal> withdrawRequests;
    private List<MerchantProductSubmission> productAudits;
    private List<MerchantContentSubmission> contentAudits;
    private List<MerchantReviewAuditDto> reviewAudits;
    private List<MerchantArtisan> artisanRecords;
    private List<String> sensitiveWords;
}
