package com.heritage.food.service;

import com.heritage.food.dto.MerchantAdminWorkspaceResponse;
import com.heritage.food.dto.MerchantApplicationOverviewResponse;
import com.heritage.food.dto.MerchantWorkspaceResponse;
import com.heritage.food.model.MerchantContentSubmission;
import com.heritage.food.model.MerchantOnboardingApplication;
import com.heritage.food.model.MerchantProfile;
import com.heritage.food.model.MerchantProductSubmission;
import com.heritage.food.model.MerchantQualificationApplication;
import com.heritage.food.model.MerchantWithdrawal;

public interface MerchantService {

    MerchantApplicationOverviewResponse getApplicationOverview(Long userId);

    MerchantOnboardingApplication submitOnboardingApplication(Long userId, MerchantOnboardingApplication request);

    MerchantWorkspaceResponse getMerchantWorkspace(Long userId, boolean isAdmin);

    MerchantProfile saveMerchantProfile(Long userId, MerchantProfile request, boolean isAdmin);

    MerchantProductSubmission saveMerchantProduct(Long userId, MerchantProductSubmission request, boolean isAdmin);

    MerchantProductSubmission updateMerchantProductStatus(Long userId, Long submissionId, String status, boolean isAdmin);

    MerchantContentSubmission saveMerchantContent(Long userId, MerchantContentSubmission request, boolean isAdmin);

    MerchantQualificationApplication submitQualificationApplication(Long userId, MerchantQualificationApplication request, boolean isAdmin);

    MerchantWithdrawal createMerchantWithdrawal(Long userId, MerchantWithdrawal request, boolean isAdmin);

    MerchantAdminWorkspaceResponse getAdminWorkspace();

    void updateMerchantRole(Long userId, boolean enabled);

    MerchantProfile updateAdminMerchantProfile(Long userId, MerchantProfile request);

    void reviewOnboarding(Long id, boolean approved);

    void reviewQualification(Long id, boolean approved);

    void updateSettlementStatus(Long id, String status);

    void updateWithdrawalStatus(Long id, String status);

    void updateProductAuditStatus(Long id, String status);

    void updateContentAuditStatus(Long id, String status);

    void updateReviewAuditStatus(Long id, String status);

    void updateArtisanStatus(Long id, String status);

    void addSensitiveWord(String word);

    void deleteSensitiveWord(String word);
}
