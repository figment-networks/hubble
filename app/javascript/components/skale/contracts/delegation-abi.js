export default [
  {
    'type': 'event',
    'anonymous': false,
    'name': 'DelegationAccepted',
    'inputs': [
      {
        'type': 'uint256',
        'name': 'delegationId',
        'indexed': false
      }
    ]
  },
  {
    'type': 'event',
    'anonymous': false,
    'name': 'DelegationProposed',
    'inputs': [
      {
        'type': 'uint256',
        'name': 'delegationId',
        'indexed': false
      }
    ]
  },
  {
    'type': 'event',
    'anonymous': false,
    'name': 'DelegationRequestCanceledByUser',
    'inputs': [
      {
        'type': 'uint256',
        'name': 'delegationId',
        'indexed': false
      }
    ]
  },
  {
    'type': 'event',
    'anonymous': false,
    'name': 'RoleGranted',
    'inputs': [
      {
        'type': 'bytes32',
        'name': 'role',
        'indexed': true
      },
      {
        'type': 'address',
        'name': 'account',
        'indexed': true
      },
      {
        'type': 'address',
        'name': 'sender',
        'indexed': true
      }
    ]
  },
  {
    'type': 'event',
    'anonymous': false,
    'name': 'RoleRevoked',
    'inputs': [
      {
        'type': 'bytes32',
        'name': 'role',
        'indexed': true
      },
      {
        'type': 'address',
        'name': 'account',
        'indexed': true
      },
      {
        'type': 'address',
        'name': 'sender',
        'indexed': true
      }
    ]
  },
  {
    'type': 'event',
    'anonymous': false,
    'name': 'UndelegationRequested',
    'inputs': [
      {
        'type': 'uint256',
        'name': 'delegationId',
        'indexed': false
      }
    ]
  },
  {
    'type': 'function',
    'name': 'DEFAULT_ADMIN_ROLE',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [],
    'outputs': [
      {
        'type': 'bytes32',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'UNDELEGATION_PROHIBITION_WINDOW_SECONDS',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'acceptPendingDelegation',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': 'delegationId'
      }
    ],
    'outputs': []
  },
  {
    'type': 'function',
    'name': 'cancelPendingDelegation',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': 'delegationId'
      }
    ],
    'outputs': []
  },
  {
    'type': 'function',
    'name': 'confiscate',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': 'validatorId'
      },
      {
        'type': 'uint256',
        'name': 'amount'
      }
    ],
    'outputs': []
  },
  {
    'type': 'function',
    'name': 'contractManager',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [],
    'outputs': [
      {
        'type': 'address',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'delegate',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': 'validatorId'
      },
      {
        'type': 'uint256',
        'name': 'amount'
      },
      {
        'type': 'uint256',
        'name': 'delegationPeriod'
      },
      {
        'type': 'string',
        'name': 'info'
      }
    ],
    'outputs': []
  },
  {
    'type': 'function',
    'name': 'delegations',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ],
    'outputs': [
      {
        'type': 'address',
        'name': 'holder'
      },
      {
        'type': 'uint256',
        'name': 'validatorId'
      },
      {
        'type': 'uint256',
        'name': 'amount'
      },
      {
        'type': 'uint256',
        'name': 'delegationPeriod'
      },
      {
        'type': 'uint256',
        'name': 'created'
      },
      {
        'type': 'uint256',
        'name': 'started'
      },
      {
        'type': 'uint256',
        'name': 'finished'
      },
      {
        'type': 'string',
        'name': 'info'
      }
    ]
  },
  {
    'type': 'function',
    'name': 'delegationsByHolder',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'address',
        'name': ''
      },
      {
        'type': 'uint256',
        'name': ''
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'delegationsByValidator',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': ''
      },
      {
        'type': 'uint256',
        'name': ''
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getAndUpdateDelegatedAmount',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'address',
        'name': 'holder'
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getAndUpdateDelegatedByHolderToValidatorNow',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'address',
        'name': 'holder'
      },
      {
        'type': 'uint256',
        'name': 'validatorId'
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getAndUpdateDelegatedToValidatorNow',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': 'validatorId'
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getAndUpdateEffectiveDelegatedByHolderToValidator',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'address',
        'name': 'holder'
      },
      {
        'type': 'uint256',
        'name': 'validatorId'
      },
      {
        'type': 'uint256',
        'name': 'month'
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': 'effectiveDelegated'
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getAndUpdateEffectiveDelegatedToValidator',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': 'validatorId'
      },
      {
        'type': 'uint256',
        'name': 'month'
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getAndUpdateForbiddenForDelegationAmount',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'address',
        'name': 'wallet'
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getAndUpdateLockedAmount',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'address',
        'name': 'wallet'
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getDelegatedToValidator',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': 'validatorId'
      },
      {
        'type': 'uint256',
        'name': 'month'
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getDelegation',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': 'delegationId'
      }
    ],
    'outputs': [
      {
        'type': 'tuple',
        'components': [
          {
            'type': 'address',
            'name': 'holder'
          },
          {
            'type': 'uint256',
            'name': 'validatorId'
          },
          {
            'type': 'uint256',
            'name': 'amount'
          },
          {
            'type': 'uint256',
            'name': 'delegationPeriod'
          },
          {
            'type': 'uint256',
            'name': 'created'
          },
          {
            'type': 'uint256',
            'name': 'started'
          },
          {
            'type': 'uint256',
            'name': 'finished'
          },
          {
            'type': 'string',
            'name': 'info'
          }
        ],
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getDelegationsByHolderLength',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'address',
        'name': 'holder'
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getDelegationsByValidatorLength',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': 'validatorId'
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getEffectiveDelegatedToValidator',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': 'validatorId'
      },
      {
        'type': 'uint256',
        'name': 'month'
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getEffectiveDelegatedValuesByValidator',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': 'validatorId'
      }
    ],
    'outputs': [
      {
        'type': 'uint256[]',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getFirstDelegationMonth',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'address',
        'name': 'holder'
      },
      {
        'type': 'uint256',
        'name': 'validatorId'
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getLockedInPendingDelegations',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'address',
        'name': 'holder'
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getRoleAdmin',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'bytes32',
        'name': 'role'
      }
    ],
    'outputs': [
      {
        'type': 'bytes32',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getRoleMember',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'bytes32',
        'name': 'role'
      },
      {
        'type': 'uint256',
        'name': 'index'
      }
    ],
    'outputs': [
      {
        'type': 'address',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getRoleMemberCount',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'bytes32',
        'name': 'role'
      }
    ],
    'outputs': [
      {
        'type': 'uint256',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'getState',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': 'delegationId'
      }
    ],
    'outputs': [
      {
        'type': 'uint8',
        'name': 'state'
      }
    ]
  },
  {
    'type': 'function',
    'name': 'grantRole',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'bytes32',
        'name': 'role'
      },
      {
        'type': 'address',
        'name': 'account'
      }
    ],
    'outputs': []
  },
  {
    'type': 'function',
    'name': 'hasRole',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'bytes32',
        'name': 'role'
      },
      {
        'type': 'address',
        'name': 'account'
      }
    ],
    'outputs': [
      {
        'type': 'bool',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'hasUnprocessedSlashes',
    'constant': true,
    'stateMutability': 'view',
    'payable': false,
    'inputs': [
      {
        'type': 'address',
        'name': 'holder'
      }
    ],
    'outputs': [
      {
        'type': 'bool',
        'name': ''
      }
    ]
  },
  {
    'type': 'function',
    'name': 'initialize',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'address',
        'name': 'contractsAddress'
      }
    ],
    'outputs': []
  },
  {
    'type': 'function',
    'name': 'processAllSlashes',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'address',
        'name': 'holder'
      }
    ],
    'outputs': []
  },
  {
    'type': 'function',
    'name': 'processSlashes',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'address',
        'name': 'holder'
      },
      {
        'type': 'uint256',
        'name': 'limit'
      }
    ],
    'outputs': []
  },
  {
    'type': 'function',
    'name': 'renounceRole',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'bytes32',
        'name': 'role'
      },
      {
        'type': 'address',
        'name': 'account'
      }
    ],
    'outputs': []
  },
  {
    'type': 'function',
    'name': 'requestUndelegation',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'uint256',
        'name': 'delegationId'
      }
    ],
    'outputs': []
  },
  {
    'type': 'function',
    'name': 'revokeRole',
    'constant': false,
    'payable': false,
    'inputs': [
      {
        'type': 'bytes32',
        'name': 'role'
      },
      {
        'type': 'address',
        'name': 'account'
      }
    ],
    'outputs': []
  }
];
