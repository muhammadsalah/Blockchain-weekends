//
//  Copyright IBM Corp. All Rights Reserved.
//
//  SPDX-License-Identifier: Apache-2.0
//
//  Modified by Muhammad Salah <muhammad.salah@eg.ibm.com>
//  Blockchain Weekends Program: Lab 1 "Blockchain Network Design"
//
//

package main

import (
	"fmt"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

type chaincode struct {

}

func (t *chaincode) Init(stub shim.ChaincodeStubInterface) pb.Response{
	fmt.Println("Blockchainweekends Chaincode in GO Init")
	return shim.Success(nil)
}

func (t *chaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response{
	
	fmt.Printf("Blockchainweekends Chaincode in GO Invoke")
	function, args := stub.GetFunctionAndParameters()
	if function == "set"{
		return t.set(stub,args)
	}
	if function == "get"{
		return t.get(stub,args)
	}
	fmt.Println("Bad chaincode functionality")
	return shim.Error("BAD")
}

func (t *chaincode) set(stub shim.ChaincodeStubInterface,args[] string) pb.Response{
	var USER string
	var STATE string
	USER = args[0]
	STATE = args [1]
	fmt.Printf("Chaincode Set is active with USER" + USER + " and STATE" + STATE + " as parameters.")
	stub.PutState(USER,[]byte(STATE))
	return shim.Success(nil)
}

func (t *chaincode) get(stub shim.ChaincodeStubInterface,args[]string) pb.Response{
	var USER string
	USER = args[0]
	fmt.Printf("Chaincode Get is active with USER" + USER + "as a parameter.")
	STATE , _ := stub.GetState(USER)
	return shim.Success(STATE)
}

func main(){
	err := shim.Start(new(chaincode))
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
	}
}