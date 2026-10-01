package com.heritage.food.dto;

import com.heritage.food.model.MerchantOnboardingApplication;
import com.heritage.food.model.MerchantQualificationApplication;
import lombok.Data;

import java.util.List;

@Data
public class MerchantApplicationOverviewResponse {
    private List<MerchantOnboardingApplication> onboardingApplications;
    private List<MerchantQualificationApplication> qualificationApplications;
}
