import Quick
import Nimble
import RxSwift
import RxCocoa
import RxOptional

class OptionalOperatorsSpec: QuickSpec {
    override func spec() {
        describe("filterNil") {
            context("Observable") {
                it("unwraps the optional") {
                    // Check on compile
                    let _: Observable<Int> = Observable<Int?>
                        .just(nil)
                        .filterNil()
                }

                it("filters nil values") {
                    Observable<Int?>
                        .of(1, nil, 3, 4)
                        .filterNil()
                        .toArray()
                        .subscribeNext {
                            expect($0).to(equal([1, 3, 4]))
                        }
                        .dispose()
                }
            }

            context("Driver") {
                it("unwraps the optional") {
                    // Check on compile
                    let _: Driver<Int> = Driver<Int?>
                        .just(nil)
                        .filterNil()
                }

                it("filters nil values") {
                    Driver<Int?>
                        .of(1, nil, 3, 4)
                        .filterNil()
                        .asObservable()
                        .toArray()
                        .subscribeNext {
                            expect($0).to(equal([1, 3, 4]))
                        }
                        .dispose()
                }
            }
        }

        describe("fatalErrorOnNil") {
            context("Observable") {
                it("unwraps the optional") {
                    // Check on compile
                    let _: Observable<Int> = Observable<Int?>
                        .just(nil)
                        .fatalErrorOnNil()
                }
            }

            context("Driver") {
                it("unwraps the optional") {
                    // Check on compile
                    let _: Driver<Int> = Driver<Int?>
                        .just(nil)
                        .fatalErrorOnNil()
                }
            }
        }

        describe("Error On Nil") {
            context("Observable") {
                it("unwraps the optional") {
                    // Check on compile
                    let _: Observable<Int> = Observable<Int?>
                        .just(nil)
                        .errorOnNil()
                }

                it("throws default error") {
                    Observable<Int?>
                        .of(1, nil, 3, 4)
                        .errorOnNil()
                        .toArray()
                        .subscribe { event in
                            switch event {
                            case .Next(let element):
                                expect(element).to(equal([1]))
                            case .Error(let error):
                                // FIXME: There should be a better way to do this and to check a more specific error.
                                expect { throw error }
                                    .to(throwError(errorType: RxOptionalError.self))
                            case .Completed:
                                break
                            }
                        }
                        .dispose()
                }
            }
        }

        describe("replaceNilWith") {
            context("Observable") {
                it("unwraps the optional") {
                    // Check on compile
                    let _: Observable<Int> = Observable<Int?>
                        .just(nil)
                        .replaceNilWith(0)
                }

                it("replaces nil values") {
                    Observable<Int?>
                        .of(1, nil, 3, 4)
                        .replaceNilWith(2)
                        .toArray()
                        .subscribeNext {
                            expect($0).to(equal([1, 2, 3, 4]))
                        }
                        .dispose()
                }
            }

            context("Driver") {
                it("unwraps the optional") {
                    // Check on compile
                    let _: Driver<Int> = Driver<Int?>
                        .just(nil)
                        .replaceNilWith(0)
                }

                it("replaces nil values") {
                    Driver<Int?>
                        .of(1, nil, 3, 4)
                        .replaceNilWith(2)
                        .asObservable()
                        .toArray()
                        .subscribeNext {
                            expect($0).to(equal([1, 2, 3, 4]))
                        }
                        .dispose()
                }
            }
        }

        describe("catchOnNil") {
            context("Observable") {
                it("unwraps the optional") {
                    // Check on compile
                    let _: Observable<Int> = Observable<Int?>
                        .just(nil)
                        .catchOnNil {
                            return Observable<Int>.just(0)
                        }
                }

                it("catches nil and continues with new observable") {
                    Observable<Int?>
                        .of(1, nil, 3, 4)
                        .catchOnNil {
                            return Observable<Int>.just(2)
                        }
                        .toArray()
                        .subscribeNext {
                            expect($0).to(equal([1, 2, 3, 4]))
                        }
                        .dispose()
                }
            }

            context("Driver") {
                it("unwraps the optional") {
                    // Check on compile
                    let _: Driver<Int> = Driver<Int?>
                        .just(nil)
                        .catchOnNil {
                            return Driver<Int>.just(0)
                        }
                }

                it("catches nil and continues with new observable") {
                    Driver<Int?>
                        .of(1, nil, 3, 4)
                        .catchOnNil {
                            return Driver<Int>.just(2)
                        }
                        .asObservable()
                        .toArray()
                        .subscribeNext {
                            expect($0).to(equal([1, 2, 3, 4]))
                        }
                        .dispose()
                }
            }
        }
    }
}
