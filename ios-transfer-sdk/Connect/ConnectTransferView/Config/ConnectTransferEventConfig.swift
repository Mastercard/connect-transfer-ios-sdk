//
//  ConnectTransferEventConfig.swift
//  Connect
//
//  Created by Anupam Kumar on 20/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

public protocol ConnectTransferEventDelegate: AnyObject {
    func onInitializeTransferDone(_ data: NSDictionary?)
    func onTermsAndConditionsAccepted(_ data: NSDictionary?)
    func onInitializeDepositSwitch(_ data: NSDictionary?)
    func onTransferEnd(_ data: NSDictionary?)
    func onUserEvent(_ data: NSDictionary?)
}

enum TransferEventDataName: String {
    
    case customerId = "customerId"
    case partnerId = "partnerId"
    case timestamp = "timestamp"
    case ttl = "ttl"
    case type = "type"
    case experience = "experience"
    case sessionId = "sessionId"
    case code = "code"
    case reason = "reason"
    case action = "action"
    case searchTerm = "searchTerm"
    case payrollProvider = "payrollProvider"
    case inputType = "inputType"
    case buttonName = "buttonName"
    case depositOption = "depositOption"
    case depositAllocation = "depositAllocation"
    case status = "status"
    case expired = "expired"
    case product = "product"
}

enum UserEvents: String{
    case INITIALIZE_TRANSFER = "InitializeTransfer"
    case TERMS_ACCEPTED = "TermsAccepted"
    case INITIALIZE_DEPOSIT_SWITCH = "InitializeDepositSwitch"
    case SEARCH_PAYROLL_PROVIDER = "SearchPayrollProvider"
    case SELECT_PAYROLL_PROVIDER = "SelectPayrollProvider"
    case SUBMIT_CREDENTIALS = "SubmitCredentials"
    case EXTERNAL_LINK = "ExternalLink"
    case CHANGE_DEFAULT_ALLOCATION = "ChangeDefaultAllocation"
    case SUBMIT_ALLOCATION = "SubmitAllocation"
    case TASK_COMPLETED = "TaskCompleted"
    case UNAUTHORIZED = "Unauthorized"
    case END = "End"
}


enum AtomicEvents: String {
    
    case INITIALIZED_TRANSACT = "Initialized Transact"
    case SEARCH_BY_COMPANY = "Search By Company"
    case SELECTED_COMPANY_FROM_SEARCH_BY_COMPANY_PAGE = "Selected Company From Search By Company Page"
    case CLICKED_CONTINUE_FROM_FORM_ON_LOGIN_PAGE = "Clicked Continue From Form On Login Page"
    case CLICKED_CONTINUE_FROM_FORM_ON_INTERRUPT_PAGE = "Clicked Continue From Form On Interrupt Page"
    case CLICKED_EXTERNAL_LOGIN_RECOVERY_LINK_FROM_LOGIN_HELP_PAGE = "Clicked External Login Recovery Link From Login Help Page"
    case CLICKED_CONTINUE_FROM_PERCENTAGE_DEPOSIT_AMOUNT_PAGE = "Clicked Continue From Percentage Deposit Amount Page"
    case CLICKED_CONTINUE_FROM_FIXED_DEPOSIT_AMOUNT_PAGE = "Clicked Continue From Fixed Deposit Amount Page"
    case CLICKED_BUTTON_TO_START_AUTHENTICATION = "Clicked Button To Start Authentication"
    case VIEWED_TASK_COMPLETED_PAGE = "Viewed Task Completed Page"
    case VIEWED_ACCESS_UNAUTHORIZED_PAGE = "Viewed Access Unauthorized Page"
    case VIEWED_EXPIRED_TOKEN_PAGE = "Viewed Expired Token Page"
}

