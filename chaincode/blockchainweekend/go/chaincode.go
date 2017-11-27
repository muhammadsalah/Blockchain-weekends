//
//  Copyright IBM Corp. All Rights Reserved.
//
//  SPDX-License-Identifier: Apache-2.0
//
//  Modified by Muhammad Salah <muhammad.salah@eg.ibm.com>
//  Blockchain Weekends Program: Lab 1 "Blockchain Network Design"
//
//

// Simple Application that stores an Invoker ID Cert alongside to a passed Key value.
// You can query the value to return that creator value.


package main 

import (
	"fmt"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

type SimpleChaincode struct{
}

func (c *SimpleChaincode) Init (stub shim.ChaincodeStubInterface) pb.Response{
	fmt.Println("Blockchainweekend Sample chaincode is in INIT")
	return shim.Success(nil)
}

func (c *SimpleChaincode) Invoke (stub shim.ChaincodeStubInterface) pb.Response{
	fmt.Println("Blockchainweeekend Sample chaincode is INVOKED")
	function, args := stub.GetFunctionAndParameters()
	switch function {
	case "enroll":
		Result:=c.enroll(stub,args)
		return Result
	case "get":
		Result:=c.get(stub,args)
		return Result
	}
	return shim.Error("Invalid invocation method")
}


func (c *SimpleChaincode) get (stub shim.ChaincodeStubInterface, args []string) pb.Response{
	fmt.Println("Blockchainweeekend Sample chaincode function get")
	key := args[0]
	creatorasbytes, _ := stub.GetState(key)
	creatorstring := fmt.Sprintf("%s",creatorasbytes)
	fmt.Println("Key: "+key)
	fmt.Println("Creator: ")
	fmt.Println(creatorstring)
	return shim.Success([]byte(creatorstring))
}

func (c *SimpleChaincode) enroll (stub shim.ChaincodeStubInterface,args []string) pb.Response{
	fmt.Println("Blockchainweekend Sample chaincode function enroll")
	key := args[0]
	creatorasbytes, _ := stub.GetCreator()
	creatorstring := fmt.Sprintf("%s",creatorasbytes)
	fmt.Println("Key: "+key)
	fmt.Println("Creator: ")
	fmt.Println(creatorstring)
	stub.PutState(key,[]byte(creatorstring))
	return shim.Success(nil)
}

func main() {
	err := shim.Start(new(SimpleChaincode))
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
	}
}
