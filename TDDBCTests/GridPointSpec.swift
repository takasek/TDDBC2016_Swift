//
//  GridPointSpec.swift
//  TDDBC
//
//  Created by Yoshitaka Seki on 2016/02/27.
//  Copyright © 2016年 Yoshitaka Seki. All rights reserved.
//

import Foundation

import Quick
import Nimble

struct GridPoint {
    let x : Int
    let y : Int
    var notation : String {
        return "(\(x),\(y))"
    }

    func isNeighborOf(gp : GridPoint) -> Bool {

        let isHorizontalNeighbor : Bool = x == gp.x - 1 || x == gp.x + 1
        let isVerticalNeighbor : Bool = y == gp.y - 1 || y == gp.y + 1

        switch (isHorizontalNeighbor, isVerticalNeighbor) {
        case (true, false): return true
        case (false, true): return true
        default: return false
        }
    }
}

struct GridPointPair {
    let gp1 : GridPoint
    let gp2 : GridPoint
    var connected: Bool { return gp1.isNeighborOf(gp2) }

    init?(gp1 : GridPoint, gp2 : GridPoint) {

        guard gp1 != gp2 else {
            return nil
        }
        self.gp1 = gp1
        self.gp2 = gp2
    }

    func contains(gp: GridPoint) -> Bool {
        return gp == gp1 || gp == gp2
    }
}

extension GridPoint: Equatable {}

func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}


class GridPointSpec: QuickSpec {

    override func spec() {
        let x = 4
        let y = 7

        describe(".notation") {
            it("returns string notation") {
                expect(GridPoint(x: 4, y: 7).notation).to(equal("(4,7)"))
                expect(GridPoint(x: 5, y: 8).notation).to(equal("(5,8)"))
            }
        }

        describe(": Equitable") {
            it("is differenciated from another GridPoint") {
                let sut = GridPoint(x: x, y: y)
                expect(sut).to(equal(sut))
                expect(sut).toNot(equal(GridPoint(x: x, y: y+1)))
                expect(sut).toNot(equal(GridPoint(x: x+1, y: y)))
            }
        }

        describe(".isNeighborOf(gp)") {
            func expectNeighborsTrue(sut1 sut1: GridPoint, sut2: GridPoint, place: String) {
                context("\(place)") {
                    it("returns true") {
                        expect(sut1.isNeighborOf(sut2)).to(beTrue())
                        expect(sut2.isNeighborOf(sut1)).to(beTrue())
                    }
                }
            }
            func expectNeighborsFalse(sut1 sut1: GridPoint, sut2: GridPoint, place: String) {
                context("\(place)") {
                    it("returns false") {
                        expect(sut1.isNeighborOf(sut2)).to(beFalse())
                        expect(sut2.isNeighborOf(sut1)).to(beFalse())
                    }
                }
            }

            let sut = GridPoint(x: x, y: y)

            context("given 1-degree gridPoint") {
                let sutUnder = GridPoint(x: x, y: y+1)
                expectNeighborsTrue(sut1: sut, sut2: sutUnder, place: "under")

                let sutAbove = GridPoint(x: x, y: y-1)
                expectNeighborsTrue(sut1: sut, sut2: sutAbove, place: "above")

                let sutLeft = GridPoint(x: x-1, y: y)
                expectNeighborsTrue(sut1: sut, sut2: sutLeft, place: "left")

                let sutRight = GridPoint(x: x+1, y: y)
                expectNeighborsTrue(sut1: sut, sut2: sutRight, place: "right")
            }

            context("given non-1-degree gridPoint") {
                context("leftUnder") {
                    it("returns false") {
                        let sutLeftUnder = GridPoint(x: x-1, y: y+1)
                        expect(sut.isNeighborOf(sutLeftUnder)).to(beFalse())
                        expect(sutLeftUnder.isNeighborOf(sut)).to(beFalse())
                    }
                }

                context("itself") {
                    it("returns false") {
                        expect(sut.isNeighborOf(sut)).to(beFalse())
                    }
                }
            }
        }
    }
}


class GridPointPairSpec: QuickSpec {

    override func spec() {

        describe(".init?") {
            context("two given points are different") {
                it("returns GridPointPair") {
                    let gp1 = GridPoint(x: 4, y: 7)
                    let gp2 = GridPoint(x: 5, y: 8)

                    expect(gp1).toNot(equal(gp2))
                    expect(GridPointPair(gp1: gp1, gp2: gp2)).toNot(beNil())
                }
                
            }

            context("two given points are the same") {
                it("returns nil") {
                    let gp = GridPoint(x: 4, y: 7)

                    expect(GridPointPair(gp1: gp, gp2: gp)).to(beNil())
                }
            }
        }

        describe(".contains(gp)") {
            context("it contains a given point") {
                it ("returns true") {
                    let gp1 = GridPoint(x: 4, y: 7)
                    let gp2 = GridPoint(x: 5, y: 8)
                    let gp3 = GridPoint(x: 5, y: 9)
                    let sut = GridPointPair(gp1: gp1, gp2: gp2)!

                    expect(sut.contains(gp1)).to(beTrue())
                    expect(sut.contains(gp2)).to(beTrue())
                    expect(sut.contains(gp3)).to(beFalse())
                }
            }
        }
        describe(".connected") {
            let x = 4
            let y = 7

            context("the members are neighbors") {
                it("returns true") {
                    let gp1 = GridPoint(x: x, y: y)
                    let gp2 = GridPoint(x: x, y: y+1)

                    expect(GridPointPair(gp1: gp1, gp2: gp2)!.connected).to(beTrue())
                }
            }

            context("the members are not neighbors") {
                it("returns false") {
                    let gp1 = GridPoint(x: x, y: y)
                    let gp2 = GridPoint(x: x+1, y: y+1)

                    expect(GridPointPair(gp1: gp1, gp2: gp2)!.connected).to(beFalse())
                }
            }
        }
    }
}